##############################################################################
# IBM Cloud Provider
##############################################################################

provider "ibm" {
  ibmcloud_api_key = var.ibmcloud_api_key
  region           = var.region
  ibmcloud_timeout = 60
}

##############################################################################

########################################################################################################################
# Landing Zone Locals
########################################################################################################################

locals {
  out = replace(file("./override.json"), "mz2o-2x16", var.machine_type)
  image = replace(local.out,"ibm-zos-2-5-s390x-dev-test-wazi-7", var.image_name)
}

##############################################################################

##############################################################################
# Landing Zone
##############################################################################
module "landing-zone" {
  source                 = "terraform-ibm-modules/landing-zone/ibm//patterns//vsi//module"
  version                = "5.18.0"
  prefix                 = var.prefix
  region                 = var.region
  ssh_public_key         = var.ssh_public_key
  override               = var.override
  override_json_string   = local.image
}

########################################################################################################################
# Resource Group
########################################################################################################################

module "resource_group" {
  source  = "terraform-ibm-modules/resource-group/ibm"
  version = "1.1.5"
  #   if an existing resource group is not set (null) create a new one using prefix
  existing_resource_group_name = "${var.prefix}-slz-management-rg"
  depends_on                   = [module.landing-zone]
}

########################################################################################################################
# Secrets Manager resources
########################################################################################################################

# Create a new SM instance if not using an existing one
module "secrets_manager" {
  source               = "terraform-ibm-modules/secrets-manager/ibm"
  version              = "1.2.1"
  resource_group_id    = module.resource_group.resource_group_id
  region               = var.region
  secrets_manager_name = "${var.prefix}-sm-instance"
  sm_service_plan      = var.sm_service_plan
  service_endpoints    = "public-and-private"
}

# Create a secret group to place the certificate in
module "secrets_manager_group" {
  source                   = "terraform-ibm-modules/secrets-manager-secret-group/ibm"
  version                  = "1.1.4"
  region                   = var.region
  secrets_manager_guid     = module.secrets_manager.secrets_manager_guid
  secret_group_name        = "${var.prefix}-certs"
  secret_group_description = "A secret group to store private certs"
  providers = {
    ibm = ibm.ibm-sm
  }
}

# Configure private cert engine if provisioning a new SM instance
module "private_secret_engine" {
  depends_on                = [module.secrets_manager]
  source                    = "terraform-ibm-modules/secrets-manager-private-cert-engine/ibm"
  version                   = "1.2.2"
  secrets_manager_guid      = module.secrets_manager.secrets_manager_guid
  region                    = var.region
  root_ca_name              = var.root_ca_name
  intermediate_ca_name      = var.intermediate_ca_name
  certificate_template_name = var.certificate_template_name
  root_ca_max_ttl           = var.root_ca_max_ttl
  root_ca_common_name       = var.root_ca_common_name
  providers = {
    ibm = ibm.ibm-sm
  }
}

# Create private cert to use for VPN server
module "secrets_manager_private_certificate" {
  depends_on             = [module.private_secret_engine]
  source                 = "terraform-ibm-modules/secrets-manager-private-cert/ibm"
  version                = "1.1.3"
  cert_name              = "${var.prefix}-cts-vpn-private-cert"
  cert_description       = "Private certificate"
  cert_template          = var.certificate_template_name
  cert_secrets_group_id  = module.secrets_manager_group.secret_group_id
  cert_common_name       = var.cert_common_name
  secrets_manager_guid   = module.secrets_manager.secrets_manager_guid
  secrets_manager_region = var.region
  providers = {
    ibm = ibm.ibm-sm
  }
}

########################################################################################################################
# VPN
########################################################################################################################

resource "time_sleep" "wait_for_security_group" {
  depends_on       = [module.client_to_site_sg.ibm_is_security_group]
  create_duration  = "10s"
  destroy_duration = "60s"
}

module "client_to_site_vpn" {
  source                        = "terraform-ibm-modules/client-to-site-vpn/ibm"
  version                       = "1.7.2"
  server_cert_crn               = module.secrets_manager_private_certificate.secret_crn
  vpn_gateway_name              = "${var.prefix}-c2s-vpn"
  resource_group_id             = module.resource_group.resource_group_id
  subnet_ids                    = [data.ibm_is_subnet.edge-vpn.id]
  create_policy                 = var.create_policy
  vpn_client_access_group_users = var.vpn_client_access_group_users
  access_group_name             = "${var.prefix}-${var.access_group_name}"
  secrets_manager_id            = module.secrets_manager.secrets_manager_guid
  vpn_server_routes             = var.vpn_server_routes
}

# Security Group for Client-to-Site VPN
module "client_to_site_sg" {
  depends_on                   = [module.landing-zone]
  source                       = "terraform-ibm-modules/security-group/ibm"
  version                      = "2.6.1"
  add_ibm_cloud_internal_rules = false
  vpc_id                       = data.ibm_is_vpc.edge.id
  resource_group               = module.resource_group.resource_group_id
  security_group_name          = "client-to-site-sg"
  security_group_rules         = [{
                  direction = "inbound"
                  name = "allow-ibm-inbound-1"
                  remote = "0.0.0.0/0"
                     udp = {
                            port_max = 443
                            port_min = 443
                        }
  }]
  target_ids                  = [module.client_to_site_vpn.vpn_server_id]
}

data "ibm_is_subnet" "edge-vpn" {
  name       = "${var.prefix}-edge-vpn-zone-1"
  depends_on = [module.landing-zone]
}

data "ibm_is_vpc" "edge" {
  name       = "${var.prefix}-edge-vpc"
  depends_on = [module.landing-zone]
}

########################################################################################################################
# Modify Security Group for Workload Resources
########################################################################################################################

data "ibm_is_security_group" "workload_wazi" {
  name = "workload-waas-sg"
  depends_on = [module.landing-zone]
}

########################################################################################################################
# Security Group Rule for Wazi VSI - zosmf Web Browser
########################################################################################################################

resource "ibm_is_security_group_rule" "wazi_security_group_web_inbound" {
  group = data.ibm_is_security_group.workload_wazi.id
  direction  = "inbound"
  tcp {
    port_min = var.port_min_zosmf
    port_max = var.port_max_zosmf
  }
}

########################################################################################################################
# Security Group Rule for Wazi VSI - Telnet
########################################################################################################################

resource "ibm_is_security_group_rule" "wazi_security_group_telnet_inbound" {
  group = data.ibm_is_security_group.workload_wazi.id
  direction  = "inbound"
  tcp {
    port_min = var.port_min_telnet
    port_max = var.port_max_telnet
  }
}

########################################################################################################################
# Modify Security Group for Site-to-site VPN
########################################################################################################################

data "ibm_is_security_group" "workload_s2s" {
  name = "site-to-site-sg"
  depends_on = [module.landing-zone]
}

########################################################################################################################
# Security Group Rule for Site-to-site VPN - zosmf Web Browser
########################################################################################################################

resource "ibm_is_security_group_rule" "s2s_security_group_web_inbound" {
  group = data.ibm_is_security_group.workload_s2s.id
  direction  = "inbound"
  tcp {
    port_min = var.port_min_zosmf
    port_max = var.port_max_zosmf
  }
}

########################################################################################################################
# Security Group Rule for Site-to-site VPN - Telnet
########################################################################################################################

resource "ibm_is_security_group_rule" "s2s_security_group_telnet_inbound" {
  group = data.ibm_is_security_group.workload_s2s.id
  direction  = "inbound"
  tcp {
    port_min = var.port_min_telnet
    port_max = var.port_max_telnet
  }
}
