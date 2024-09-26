##############################################################################
# Landing Zone Locals
##############################################################################

locals {
  out   = replace(var.override_json_string, "mz2o-2x16", var.machine_type)
  image = replace(local.out, "ibm-zos-3-1-s390x-dev-test-wazi-1", var.image_name)
}
##############################################################################
# QuickStart VSI Landing Zone
##############################################################################

module "landing_zone" {
  source               = "terraform-ibm-modules/landing-zone/ibm//patterns//vsi//module"
  version              = "6.0.1"
  prefix               = var.prefix
  region               = var.region
  ssh_public_key       = var.ssh_key
  override_json_string = local.image
}

########################################################################################################################
# Modify Security Group Rule for Workload Resources
########################################################################################################################

data "ibm_is_security_group" "workload" {
  name       = "workload-sg"
  depends_on = [module.landing_zone]
}

########################################################################################################################
# Security Group Rule for Wazi VSI
########################################################################################################################

resource "ibm_is_security_group_rule" "workload_security_group_inbound" {
  for_each  = toset([for v in var.ports : tostring(v)])
  group     = data.ibm_is_security_group.workload.id
  direction = "inbound"
  tcp {
    port_min = each.value
    port_max = each.value
  }
}

########################################################################################################################
# Additional Data volumes for Wazi VSI (Optional)
########################################################################################################################

resource "ibm_is_instance_volume_attachment" "vsi" {
  instance = data.ibm_is_instance.wazi.id
  for_each = { for vsi in var.data_volume_names : vsi.name => vsi }

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
  name = module.landing_zone.vsi_list[0].name
}
