terraform {
  required_version = ">= 1.3"
  required_providers {
    # Lock DA into an exact provider version - renovate automation will keep it updated
    ibm = {
      source  = "IBM-Cloud/ibm"
      version = "1.85.0"
    }
  }
}
