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
