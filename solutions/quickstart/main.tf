##############################################################################
# Landing Zone Locals
##############################################################################

locals {
  out = replace(var.override_json_string,"mz2o-2x16",var.machine_type)
  image = replace(local.out,"ibm-zos-2-5-s390x-dev-test-wazi-7", var.image_name)
}
##############################################################################
# QuickStart VSI Landing Zone
##############################################################################

module "landing_zone" {
  source    = "terraform-ibm-modules/landing-zone/ibm//patterns//vsi-quickstart"
  version   = "5.18.0"
  ibmcloud_api_key     = var.ibmcloud_api_key
  prefix               = var.prefix
  region               = var.region
  ssh_key              = var.ssh_key
  override_json_string = local.image
}

########################################################################################################################
# Modify Security Group Rule for Workload Resources
########################################################################################################################

data "ibm_is_security_group" "workload" {
  name = "workload-sg"
  depends_on = [module.landing_zone]
}

########################################################################################################################
# Security Group Rule for Wazi VSI - zosmf Web Browser
########################################################################################################################

resource "ibm_is_security_group_rule" "workload_security_group_web_inbound" {
  group = data.ibm_is_security_group.workload.id
  direction  = "inbound"
  tcp {
    port_min = var.port_min_in
    port_max = var.port_max_in
  }
}

########################################################################################################################
# Security Group Rule for Wazi VSI - Telnet
########################################################################################################################

resource "ibm_is_security_group_rule" "workload_security_group_telnet_inbound" {
  group = data.ibm_is_security_group.workload.id
  direction  = "inbound"
  tcp {
    port_min = var.port_min
    port_max = var.port_max
  }
}
