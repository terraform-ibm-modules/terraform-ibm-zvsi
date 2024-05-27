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
  validation {
    error_message = "Prefix must begin with a lowercase letter and contain only lowercase letters, numbers, and - characters. Prefixes must end with a lowercase letter or number and be 16 or fewer characters."
    condition     = can(regex("^([a-z]|[a-z][-a-z0-9]*[a-z0-9])$", var.prefix)) && length(var.prefix) <= 16
  }
}

variable "region" {
  description = "Region where all the resources will be created. Use `ibmcloud is regions` command to find available regions."
  type        = string
  validation {
    condition     = contains(["jp-osa", "jp-tok", "kr-seo", "eu-de", "eu-es", "eu-fr2", "eu-gb", "ca-tor", "us-south", "us-south-test", "us-east", "br-sao", "au-syd"], var.region)
    error_message = "Enter valid region for WaziaaS"
  }
}

variable "ssh_public_key" {
  description = "A public SSH Key for VSI creation which does not already exist in the deployment region. Must be an RSA key with a key size of either 2048 bits or 4096 bits (recommended) - See https://cloud.ibm.com/docs/vpc?topic=vpc-ssh-keys. To use an existing key, enter a value for the variable 'existing_ssh_key_name' instead."
  type        = string
  validation {
    error_message = "Public SSH Key must be a valid ssh rsa public key."
    condition     = var.ssh_public_key == null || can(regex("ssh-rsa AAAA[0-9A-Za-z+/]+[=]{0,3} ?([^@]+@[^@]+)?", var.ssh_public_key))
  }
}

variable "machine_type" {
  type        = string
  default     = "mz2-2x16"
  description = "input machine type: valid values are: bz2-4x16, bz2-8x32, bz2-16x64, cz2-8x16, cz2-16x32, mz2-2x16, mz2-4x32, mz2-8x64, mz2-16x128"
  validation {
    condition     = contains(["mz2o-2x16", "bz2-4x16", "bz2-8x32", "bz2-16x64", "cz2-8x16", "cz2-16x32", "mz2-2x16", "mz2-4x32", "mz2-8x64", "mz2-16x128"], var.machine_type)
    error_message = "Valid values for machine_type are: bz2-4x16, bz2-8x32, bz2-16x64, cz2-8x16, cz2-16x32, mz2-2x16, mz2-4x32, mz2-8x64, mz2-16x128"
  }
}

variable "image_name" {
  description = "Enter a valid image name for Wazi VSI"
  type        = string
  default     = "ibm-zos-3-1-s390x-dev-test-wazi-1"
}

variable "override" {
  description = "Override default values with custom JSON template. This uses the file `override.json` to allow users to create a fully customized environment."
  type        = bool
  default     = true
}

variable "sm_service_plan" {
  type        = string
  description = "Type of service plan to use to provision Secrets Manager if not using an existing one."
  default     = "trial"
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
  description = "Enter the list of ports to open for Wazi VSI SG."
  type        = list(number)
  default     = [21, 992, 9443, 10443, 8101, 8102, 8120, 8121, 8150, 8153, 8154, 8155, 8180, 8135, 8191, 8192, 8194, 8137, 8138, 8139, 8115, 8195, 12000, 12001, 12002, 12003, 12004, 12005, 12006, 12007, 12008, 12009, 12010, 12011, 12012, 12013, 12014, 12015, 12016, 12017, 12018, 12019, 12020, 12021, 12022, 12023, 12024, 12025, 12026, 12027, 12028, 12029]
}

variable "data_volume_names" {
  description = "Enter the details of Data Volume creation. Refer https://github.com/terraform-ibm-modules/terraform-ibm-zvsi/tree/main/solutions/standard/README.md for input value"
  type = list(object({
    name        = string
    capacity    = number
    volume_name = string
  }))
  default = []
  validation {
    error_message = "Enter a size between 10 GB and 16000 GB."
    condition = length([
      for o in var.data_volume_names :
      o.capacity > 10 && o.capacity < 16000
    ]) == length(var.data_volume_names)
  }

  validation {
    error_message = "Each Data volume name must have a unique name."
    condition = length(
      distinct(
        [
          for data_volume_name in var.data_volume_names :
          data_volume_name.name if lookup(data_volume_name, "name", null) != null
        ]
      )
      ) == length(
      [
        for data_volume_name in var.data_volume_names :
        data_volume_name.name if lookup(data_volume_name, "name", null) != null
      ]
    )
  }

  validation {
    error_message = "Each volume name must have a unique name."
    condition = length(
      distinct(
        [
          for data_volume_name in var.data_volume_names :
          data_volume_name.volume_name if lookup(data_volume_name, "volume_name", null) != null
        ]
      )
      ) == length(
      [
        for data_volume_name in var.data_volume_names :
        data_volume_name.volume_name if lookup(data_volume_name, "volume_name", null) != null
      ]
    )
  }
}
