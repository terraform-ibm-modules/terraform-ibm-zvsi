########################################################################################################################
# Landing Zone Locals
########################################################################################################################

locals {
  out   = replace(file("./override.json"), "mz2o-2x16", var.machine_type)
  image = replace(local.out, "ibm-zos-3-1-s390x-dev-test-wazi-1", var.image_name)
}

##############################################################################

##############################################################################
# Landing Zone
##############################################################################
module "landing_zone" {
  source               = "terraform-ibm-modules/landing-zone/ibm//patterns//vsi//module"
  version              = "5.31.2"
  prefix               = var.prefix
  region               = var.region
  ssh_public_key       = var.ssh_public_key
  override             = var.override
  override_json_string = local.image
}

########################################################################################################################
# Resource Group
########################################################################################################################

module "resource_group" {
  source  = "terraform-ibm-modules/resource-group/ibm"
  version = "1.1.6"
  # NB This naming conventation must match what is used in the override.json
  # TODO: Get the resource group from the landing_zone module output instead to ensure value is correct
  existing_resource_group_name = "${var.prefix}-management-rg"
  depends_on                   = [module.landing_zone]
}

########################################################################################################################
# Secrets Manager resources
########################################################################################################################

# Create a new SM instance if not using an existing one
module "secrets_manager" {
  source               = "terraform-ibm-modules/secrets-manager/ibm"
  version              = "1.18.0"
  resource_group_id    = module.resource_group.resource_group_id
  region               = var.region
  secrets_manager_name = "${var.prefix}-sm-instance"
  sm_service_plan      = var.sm_service_plan
  allowed_network      = "public-and-private"
}

# Create a secret group to place the certificate in
module "secrets_manager_group" {
  source                   = "terraform-ibm-modules/secrets-manager-secret-group/ibm"
  version                  = "1.2.2"
  region                   = var.region
  secrets_manager_guid     = module.secrets_manager.secrets_manager_guid
  secret_group_name        = "${var.prefix}-certs"
  secret_group_description = "A secret group to store private certs"
}

# Configure private cert engine if provisioning a new SM instance
module "private_secret_engine" {
  depends_on                = [module.secrets_manager]
  source                    = "terraform-ibm-modules/secrets-manager-private-cert-engine/ibm"
  version                   = "1.3.2"
  secrets_manager_guid      = module.secrets_manager.secrets_manager_guid
  region                    = var.region
  root_ca_name              = var.root_ca_name
  intermediate_ca_name      = var.intermediate_ca_name
  certificate_template_name = var.certificate_template_name
  root_ca_max_ttl           = var.root_ca_max_ttl
  root_ca_common_name       = var.root_ca_common_name
}

# Create private cert to use for VPN server
module "secrets_manager_private_certificate" {
  depends_on             = [module.private_secret_engine]
  source                 = "terraform-ibm-modules/secrets-manager-private-cert/ibm"
  version                = "1.3.1"
  cert_name              = "${var.prefix}-cts-vpn-private-cert"
  cert_description       = "Private certificate"
  cert_template          = var.certificate_template_name
  cert_secrets_group_id  = module.secrets_manager_group.secret_group_id
  cert_common_name       = var.cert_common_name
  secrets_manager_guid   = module.secrets_manager.secrets_manager_guid
  secrets_manager_region = var.region
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
  version                       = "1.7.18"
  server_cert_crn               = module.secrets_manager_private_certificate.secret_crn
  vpn_gateway_name              = "${var.prefix}-c2s-vpn"
  resource_group_id             = module.resource_group.resource_group_id
  subnet_ids                    = [data.ibm_is_subnet.edge_vpn.id]
  create_policy                 = var.create_policy
  vpn_client_access_group_users = var.vpn_client_access_group_users
  access_group_name             = "${var.prefix}-${var.access_group_name}"
  secrets_manager_id            = module.secrets_manager.secrets_manager_guid
  vpn_server_routes             = var.vpn_server_routes
}

# Security Group for Client-to-Site VPN
module "client_to_site_sg" {
  depends_on                   = [module.landing_zone]
  source                       = "terraform-ibm-modules/security-group/ibm"
  version                      = "2.6.2"
  add_ibm_cloud_internal_rules = false
  vpc_id                       = data.ibm_is_vpc.edge.id
  resource_group               = module.resource_group.resource_group_id
  security_group_name          = "client-to-site-sg"
  security_group_rules = [{
    direction = "inbound"
    name      = "allow-ibm-inbound-1"
    remote    = "0.0.0.0/0"
    udp = {
      port_max = 443
      port_min = 443
    }
  }]
  target_ids = [module.client_to_site_vpn.vpn_server_id]
}

data "ibm_is_subnet" "edge_vpn" {
  name       = "${var.prefix}-edge-vpn-zone-1"
  depends_on = [module.landing_zone]
}

data "ibm_is_vpc" "edge" {
  name       = "${var.prefix}-edge-vpc"
  depends_on = [module.landing_zone]
}

########################################################################################################################
# Modify Security Group for Workload Resources
########################################################################################################################

data "ibm_is_security_group" "workload_wazi" {
  name       = "workload-waas-sg"
  depends_on = [module.landing_zone]
}

########################################################################################################################
# Security Group Rule for Wazi VSI
########################################################################################################################

resource "ibm_is_security_group_rule" "wazi_security_group_inbound" {
  for_each  = toset([for v in var.ports : tostring(v)])
  group     = data.ibm_is_security_group.workload_wazi.id
  direction = "inbound"
  local     = "0.0.0.0/0"
  tcp {
    port_min = each.value
    port_max = each.value
  }
}

########################################################################################################################
# Modify Security Group for Site-to-site VPN
########################################################################################################################

data "ibm_is_security_group" "workload_s2s" {
  name       = "site-to-site-sg"
  depends_on = [module.landing_zone]
}

########################################################################################################################
# Security Group Rule for Site-to-site VPN
########################################################################################################################

resource "ibm_is_security_group_rule" "s2s_security_group_inbound" {
  for_each  = toset([for v in var.ports : tostring(v)])
  group     = data.ibm_is_security_group.workload_s2s.id
  direction = "inbound"
  local     = "0.0.0.0/0"
  tcp {
    port_min = each.value
    port_max = each.value
  }
}

########################################################################################################################
# Additional Data volumes for Wazi VSI (Optional)
########################################################################################################################

########################################################################################################################
# Additional Data volumes for Wazi VSI (Optional)
########################################################################################################################

resource "ibm_is_instance_volume_attachment" "example" {
  instance = data.ibm_is_instance.wazi.id
  for_each = { for example in var.data_volume_names : example.name => example }

  name                               = each.key
  profile                            = "general-purpose"
  capacity                           = each.value.capacity
  delete_volume_on_attachment_delete = true
  delete_volume_on_instance_delete   = true
  volume_name                        = each.value.volume_name

  #User can configure timeouts
  timeouts {
    create = "15m"
    update = "15m"
    delete = "15m"
  }
}

data "ibm_is_instance" "wazi" {
  name       = "${var.prefix}-workload-server-001"
  depends_on = [module.landing_zone]
}
