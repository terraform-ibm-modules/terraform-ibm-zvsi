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
  default     = "z-vsi-qs"

  validation {
    error_message = "Prefix must begin with a lowercase letter and contain only lowercase letters, numbers, and - characters. Prefixes must end with a lowercase letter or number and be 16 or fewer characters."
    condition     = can(regex("^([a-z]|[a-z][-a-z0-9]*[a-z0-9])$", var.prefix)) && length(var.prefix) <= 16
  }
}

variable "region" {
  description = "Region where VPC will be created. To find your VPC region, use `ibmcloud is regions` command to find available regions."
  type        = string
  default     = "br-sao"
}

variable "ssh_key" {
  description = "A public SSH Key for VSI creation which does not already exist in the deployment region. Must be an RSA key with a key size of either 2048 bits or 4096 bits (recommended) - See https://cloud.ibm.com/docs/vpc?topic=vpc-ssh-keys."
  type        = string
  validation {
    error_message = "Public SSH Key must be a valid ssh rsa public key."
    condition     = can(regex("ssh-rsa AAAA[0-9A-Za-z+/]+[=]{0,3} ?([^@]+@[^@]+)?", var.ssh_key))
  }
}

variable "resource_tags" {
  type        = list(string)
  description = "Optional list of tags to be added to created resources"
  default     = []
}

variable "override_json_string" {
  description = "Override default values with custom JSON. Any value here other than an empty string will override all other configuration changes."
  type        = string
  default     = <<EOF
{
   "atracker": {
      "collector_bucket_name": "",
      "receive_global_events": false,
      "resource_group": "",
      "add_route": false
   },
   "clusters": [],
   "cos": [],
   "enable_transit_gateway": false,
   "transit_gateway_global": false,
   "key_management": {},
   "network_cidr": "10.0.0.0/8",
   "resource_groups": [
      {
         "create": false,
         "name": "service-rg",
         "use_prefix": true
      },
      {
         "create": false,
         "name": "management-rg",
         "use_prefix": true
      },
      {
         "create": true,
         "name": "workload-rg",
         "use_prefix": true
      }
   ],
   "security_groups": [],
   "transit_gateway_connections": [],
   "transit_gateway_resource_group": "",
   "virtual_private_endpoints": [],
   "vpcs": [
      {
         "default_security_group_rules": [],
         "clean_default_sg_acl": true,
         "flow_logs_bucket_name": null,
         "network_acls": [
            {
               "add_cluster_rules": false,
               "name": "workload-acl",
               "rules": [
                  {
                     "action": "allow",
                     "destination": "10.0.0.0/8",
                     "direction": "inbound",
                     "name": "allow-ibm-inbound",
                     "source": "161.26.0.0/16"
                  },
                  {
                     "action": "allow",
                     "destination": "10.0.0.0/8",
                     "direction": "inbound",
                     "name": "allow-all-network-inbound",
                     "source": "10.0.0.0/8"
                  },
                  {
                     "action": "allow",
                     "destination": "0.0.0.0/0",
                     "direction": "outbound",
                     "name": "allow-all-outbound",
                     "source": "0.0.0.0/0"
                  }
               ]
            }
         ],
         "prefix": "workload",
         "resource_group": "workload-rg",
         "subnets": {
            "zone-1": [
               {
                  "acl_name": "workload-acl",
                  "cidr": "10.40.10.0/24",
                  "name": "vsi-zone-1",
                  "public_gateway": false
               }
            ],
            "zone-2": [],
            "zone-3": []
         },
         "use_public_gateways": {
            "zone-1": false,
            "zone-2": false,
            "zone-3": false
         },
         "address_prefixes": {
            "zone-1": [],
            "zone-2": [],
            "zone-3": []
         }
      }
   ],
   "vpn_gateways": [],
   "vsi": [
      {
         "boot_volume_encryption_key_name": "",
         "image_name": "ibm-zos-2-5-s390x-dev-test-wazi-4",
         "machine_type": "mz2-2x16",
         "name": "workload-server",
         "resource_group": "workload-rg",
         "security_group": {
            "name": "workload",
            "rules": [
               {
                  "direction": "inbound",
                  "name": "allow-ibm-inbound",
                  "source": "161.26.0.0/16"
               },
               {
                  "direction": "inbound",
                  "name": "allow-vpc-inbound",
                  "source": "10.0.0.0/8"
               },
               {
                  "direction": "outbound",
                  "name": "allow-all-outbound",
                  "source": "0.0.0.0/0"
               }
            ]
         },
         "ssh_keys": [
            "ssh-key"
         ],
         "subnet_names": [
            "vsi-zone-1"
         ],
         "vpc_name": "workload",
         "vsi_per_subnet": 1,
         "enable_floating_ip": true
      }
   ]
}
EOF
}