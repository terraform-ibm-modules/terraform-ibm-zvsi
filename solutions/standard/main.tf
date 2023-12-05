##############################################################################
# IBM Cloud Provider
##############################################################################

provider "ibm" {
  ibmcloud_api_key = var.ibmcloud_api_key
  region           = var.region
  ibmcloud_timeout = 60
}

##############################################################################


##############################################################################
# Landing Zone
##############################################################################
module "landing-zone" {
  source  = "terraform-ibm-modules/landing-zone/ibm//patterns/vsi"
  version = "4.13.0"
  prefix                              = var.prefix
  region                              = var.region
  ibmcloud_api_key                    = var.ibmcloud_api_key 
  ssh_public_key                      = var.ssh_public_key
#  override_json_string                = var.override_json_string
  override                            = var.override
}


