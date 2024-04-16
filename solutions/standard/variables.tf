##############################################################################
# Account Variables
##############################################################################

variable "ibmcloud_api_key" {
  description = "The IBM Cloud platform API key needed to deploy IAM enabled resources."
  type        = string
  sensitive   = true
}

variable "prefix" {
  description = "A unique identifier for resources. Must begin with a lowercase letter and end with a lowerccase letter or number. This prefix will be prepended to any resources provisioned by this template. Prefixes must be 16 or fewer characters."
  type        = string
  default = "kps"
  validation {
    error_message = "Prefix must begin with a lowercase letter and contain only lowercase letters, numbers, and - characters. Prefixes must end with a lowercase letter or number and be 16 or fewer characters."
    condition     = can(regex("^([a-z]|[a-z][-a-z0-9]*[a-z0-9])$", var.prefix)) && length(var.prefix) <= 16
  }
}

variable "region" {
  description = "Region where VPC will be created. To find your VPC region, use `ibmcloud is regions` command to find available regions."
  type        = string
  default = "br-sao"
  validation {
    condition     = contains(["jp-osa", "jp-tok", "kr-seo", "eu-de", "eu-es", "eu-fr2", "eu-gb", "ca-tor", "us-south", "us-south-test", "us-east", "br-sao", "au-syd"], var.region)
    error_message = "Enter valid region for WaziaaS"
  }
}

variable "ssh_public_key" {
  description = "A public SSH Key for VSI creation which does not already exist in the deployment region. Must be an RSA key with a key size of either 2048 bits or 4096 bits (recommended) - See https://cloud.ibm.com/docs/vpc?topic=vpc-ssh-keys. To use an existing key, enter a value for the variable 'existing_ssh_key_name' instead."
  type        = string
  default = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQC2SHQIQomwT+SfMsNx8hIZCPJGw96bVROvrqBmYlx+P45oUNltBZYVnXEFlcjPZrdQ/0e0ZdbZY1i2aakBP5qakW0AJ6wPmXQacZYdDlI0SkP6Th01m2YDUkIvQ23l0Ym4xV5ZsYcarmizj/cYqamC4SQxerc1F/eyNol3IcMIRTC5vvoXvZjVZSfN4o5bUp9D3rretO+rgbhkTtYPclrH9j0c0AkQkewu4InfCFKMfvJ1vbCtRw1FS8rKPV5RdPFbQ6AtEToFXdTDhfyPVAiNNfzF4Pustv7jv/fA3LgEaAE90q7xzJ8/e5dPfIL0F7TZ2slNpW/NQAZOb3hsX+M0JIGkKnOCWUNWH9dzBF5U/32JYojRxGbW3SCl1zGA02hT+A7IaRhZxyqTgEikm3xbxBqzo/cywXlxOOn2lm3AiyxzWUe7Dt+GvJKPWpMucSSS6YSE2fPuDNufDlT61eSRC/V18vyratDeFizO4dVOrE6PsipISKjJJKS5rYxxAac= root@akshay-x86"
  validation {
    error_message = "Public SSH Key must be a valid ssh rsa public key."
    condition     = var.ssh_public_key == null || can(regex("ssh-rsa AAAA[0-9A-Za-z+/]+[=]{0,3} ?([^@]+@[^@]+)?", var.ssh_public_key))
  }
}

variable "machine_type" {
  type = string 
  default = "bz2-4x16"
  description = "input machine type: valid values are: bz2-4x16, bz2-8x32, bz2-16x64, cz2-8x16, cz2-16x32, mz2-2x16, mz2-4x32, mz2-8x64, mz2-16x128"
  validation {
    condition  = contains(["mz2o-2x16","bz2-4x16", "bz2-8x32", "bz2-16x64", "cz2-8x16", "cz2-16x32", "mz2-2x16", "mz2-4x32", "mz2-8x64", "mz2-16x128"], var.machine_type)
    error_message = "Valid values for machine_type are: bz2-4x16, bz2-8x32, bz2-16x64, cz2-8x16, cz2-16x32, mz2-2x16, mz2-4x32, mz2-8x64, mz2-16x128"
  }
}

variable "image_name" {
   description = "Enter a valid image name for Wazi VSI"
   type        = string
   default     = "ibm-zos-2-5-s390x-dev-test-wazi-7"
}

variable "override" {
description = "Override default values with custom JSON template. This uses the file `override.json` to allow users to create a fully customized environment."
type        = bool
default     = true
}

variable "sm_service_plan" {
  type        = string
  description = "Type of service plan to use to provision Secrets Manager if not using an existing one."
  default     = "standard"
}

variable "root_ca_name" {
  type        = string
  description = "Name of the Root CA to create for a private_cert secret engine. Only used when var.existing_sm_instance_guid is false"
  default     = "root-ca"
}

variable "intermediate_ca_name" {
  type        = string
  description = "Name of the Intermediate CA to create for a private_cert secret engine. Only used when var.existing_sm_instance_guid is false"
  default     = "intermediate-ca"
}

variable "certificate_template_name" {
  type        = string
  description = "Name of the Certificate Template to create for a private_cert secret engine. When var.existing_sm_instance_guid is true, then it has to be the existing template name that exists in the private cert engine."
  default     = "my-template"
}

variable "create_policy" {
  description = "Set to true to create a new access group (using the value of var.access_group_name) with a VPN Client role"
  type        = bool
  default     = true
}

variable "vpn_client_access_group_users" {
  description = "List of users in the Client to Site VPN Access Group"
  type        = list(string)
  default     = []
}

variable "access_group_name" {
  type        = string
  description = "Name of the IAM Access Group to create if var.create_policy is true"
  default     = "client-to-site-vpn-access-group"
}

variable "vpn_server_routes" {
  type = map(object({
    destination = string
    action      = string
  }))
  description = "Map of server routes to be added to created VPN server."
  default = {
    "vpn-ibm-network" = {
      destination = "10.0.0.0/8"
      action      = "translate"
    }
    "route-vpn-2-services" = {
      destination = "166.9.0.0/16"
      action      = "translate"
    }
    "route-vpn-2-dns" = {
      destination = "161.26.0.0/24"
      action      = "translate"
    }
  }
}

variable "root_ca_max_ttl" {
  type        = string
  description = "Maximum TTL value for the root CA"
  default     = "8760h"
}

variable "root_ca_common_name" {
  type        = string
  description = "Fully qualified domain name or host domain name for the certificate to be created"
  default     = "cloud.ibm.com"
}

variable "resource_group" {
  type        = string
  description = "Name of the resource group to use for this example. If not set, a resource group is created."
  default = null
}

variable "cert_common_name" {
  type        = string
  description = "Fully qualified domain name or host domain name for the private certificate to be created"

  validation {
    condition     = length(var.cert_common_name) >= 4 && length(var.cert_common_name) <= 128
    error_message = "length of cert_common_name must be >= 4 and <= 128"
  }

  validation {
    condition     = can(regex("(.*?)", var.cert_common_name))
    error_message = "cert_common_name must match regular expression /(.*?)/"
  }
}

variable "ports" {
  description = "Enter the list of ports to open for Wazi VSI SG. For example, Enter a value: ["992", "10443", "9443"]"
  type        = list(string)
}

variable "override_json_string" {
  description = "Override default values with custom JSON. Any value here other than an empty string will override all other configuration changes."
  type        = string
  default     = ""
}
