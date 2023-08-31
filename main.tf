##############################################################################
# Landing Zone VSI Pattern
##############################################################################

module "landing_zone" {
  source            = "git::https://github.com/terraform-ibm-modules/terraform-ibm-landing-zone-vpc.git?ref=v5.0.1"
  prefix            = var.prefix
  region            = var.region
  #ibmcloud_api_key  = var.ibmcloud_api_key
  #ssh_public_key    = var.ssh_key
  #override         = true
  tags              = var.resource_tags
  name              = var.name
  resource_group_id = var.resource_group_id
}
