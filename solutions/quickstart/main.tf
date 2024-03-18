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
  override_json_string = var.override_json_string
}

########################################################################################################################
# Modify Security Group for Workload VSI
########################################################################################################################

data "ibm_is_security_group" "workload" {
  name = "workload-sg"
  depends_on = [module.landing_zone]
}

resource "ibm_is_security_group_rule" "workload_security_group_web_inbound" {
  group = data.ibm_is_security_group.workload.id
  direction  = "inbound"
  tcp {
    port_min = var.port_min_in
    port_max = var.port_max_in
  }
}

resource "ibm_is_security_group_rule" "workload_security_group_telnet_inbound" {
  group = data.ibm_is_security_group.workload.id
  direction  = "inbound"
  tcp {
    port_min = var.port_min
    port_max = var.port_max
  }
}
