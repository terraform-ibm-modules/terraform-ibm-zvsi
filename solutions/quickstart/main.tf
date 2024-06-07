##############################################################################
# Landing Zone Locals
##############################################################################

locals {
  out   = replace(var.override_json_string, "mz2o-2x16", var.machine_type)
  image = replace(local.out, "ibm-zos-3-1-s390x-dev-test-wazi-1", var.image_name)
  ssh   = replace(local.image, "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQDIuoyXdQkgUs9cIaLw5GGVDQD356VqbGh0CbEf1vc6eEmJ6i7puJ8Xu+pPL+pNXaB/gxbF3HnPYoRDqLGMl5brV/phBOpq1wLzqRhtbVOaxpRJBreBJxv++vKoFw7wlZTogukHYm6ARfMTMgdYqce75UN6isqrZA0RbhpbDoryddCWhKWiCkAXhGfnpC0pC7SghLmFmUyMZw2iB606hnr8f/VplotaQUpOG7P9hy3JO9UZsMxE5LDyEQuPZ/H69IFcWJjR1BHTMq8aHje9bXvgxEwx3ShJ+4Nt4IU4hU9XBQ6vA/4cOP+EJcaHtmopqy9hauo/4cS7zW1ps67z1xzRrw+qi2Cb6MnqgkU/NwsnxDGuvvL/DsXgMJUnGEgNEU8zTI+j39RZG2jRGAfdQ1D4ZPTA45eGMjunHcQLFm8fBWcfrFu0negW5REw3nj8mNh+56ZFYrbpMZpSrMOQogdbfvU0RKvwhk+mDSAzdlvYQy/r6U/Tlj3MxCgDMrga+WU= root@akshay-x86", var.ssh_public_key)
}
##############################################################################
# QuickStart VSI Landing Zone
##############################################################################

module "landing_zone" {
  source               = "terraform-ibm-modules/landing-zone/ibm//patterns//vsi//module"
  version              = "5.22.0"
  prefix               = var.prefix
  region               = var.region
  override_json_string = local.ssh
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
  local     = "0.0.0.0/0"
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
  name       = "${var.prefix}-workload-server-001"
  depends_on = [module.landing_zone]
}
