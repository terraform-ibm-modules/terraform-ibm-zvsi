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

variable "ssh_key" {
  description = "A public SSH Key for VSI creation which does not already exist in the deployment region. Must be an RSA key with a key size of either 2048 bits or 4096 bits (recommended) - See https://cloud.ibm.com/docs/vpc?topic=vpc-ssh-keys."
  type        = string
  default = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQC2SHQIQomwT+SfMsNx8hIZCPJGw96bVROvrqBmYlx+P45oUNltBZYVnXEFlcjPZrdQ/0e0ZdbZY1i2aakBP5qakW0AJ6wPmXQacZYdDlI0SkP6Th01m2YDUkIvQ23l0Ym4xV5ZsYcarmizj/cYqamC4SQxerc1F/eyNol3IcMIRTC5vvoXvZjVZSfN4o5bUp9D3rretO+rgbhkTtYPclrH9j0c0AkQkewu4InfCFKMfvJ1vbCtRw1FS8rKPV5RdPFbQ6AtEToFXdTDhfyPVAiNNfzF4Pustv7jv/fA3LgEaAE90q7xzJ8/e5dPfIL0F7TZ2slNpW/NQAZOb3hsX+M0JIGkKnOCWUNWH9dzBF5U/32JYojRxGbW3SCl1zGA02hT+A7IaRhZxyqTgEikm3xbxBqzo/cywXlxOOn2lm3AiyxzWUe7Dt+GvJKPWpMucSSS6YSE2fPuDNufDlT61eSRC/V18vyratDeFizO4dVOrE6PsipISKjJJKS5rYxxAac= root@akshay-x86"
  validation {
    error_message = "Public SSH Key must be a valid ssh rsa public key."
    condition     = can(regex("ssh-rsa AAAA[0-9A-Za-z+/]+[=]{0,3} ?([^@]+@[^@]+)?", var.ssh_key))
  }
}

variable "machine_type" {
  type = string 
  description = "input machine type: valid values are: bz2-4x16, bz2-8x32, bz2-16x64, cz2-8x16, cz2-16x32, mz2-2x16, mz2-4x32, mz2-8x64, mz2-16x128"
  default = "bz2-4x16"
  validation {
    condition  = contains(["mz2o-2x16", "bz2-4x16", "bz2-8x32", "bz2-16x64", "cz2-8x16", "cz2-16x32", "mz2-2x16", "mz2-4x32", "mz2-8x64", "mz2-16x128"], var.machine_type)
    error_message = "Valid values for machine_type are: bz2-4x16, bz2-8x32, bz2-16x64, cz2-8x16, cz2-16x32, mz2-2x16, mz2-4x32, mz2-8x64, mz2-16x128"
  }
}

variable "image_name" {
   description = "Enter a valid image name for Wazi VSI"
   type        = string
   default     = "ibm-zos-2-5-s390x-dev-test-wazi-7"
}

variable "resource_tags" {
  type        = list(string)
  description = "Optional list of tags to be added to created resources"
  default     = []
}

variable "ports" {
  description = "Enter the list of ports to open for Wazi VSI SG. For example : [992, 10443]"
  type        = list(string)
  validation {
    condition  = can(regex("^([0-9]))?$", var.ports)
    error_message = "Valid values for ports are:"
  }
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
   "key_management": {
        "keys": [
        ],
        "name": null,
        "resource_group": null,
        "use_hs_crypto": false,
        "use_data": false
   },
   "network_cidr": "10.0.0.0/8",
   "resource_groups": [
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
         "default_security_group_name": "workload-vpc-sg",
         "default_security_group_rules": [
	   {
                  "direction": "inbound",
                  "name": "allow-ibm-inbound",
                  "remote": "0.0.0.0/0",
                  "tcp": {
                            "port_max": 22,
                            "port_min": 22
                        }
	   },
	   {
                  "direction": "inbound",
                  "name": "allow-ibm-inbound-1",
                  "remote": "0.0.0.0/0",
                  "icmp": {
                            "type": 8
                        }
            },
	    {
                  "direction": "inbound",
                  "name": "allow-ibm-inbound-2",
                  "remote": "0.0.0.0/0",
                     "udp": {
                            "port_max": 443,
                            "port_min": 443
                        }
           }
	 ],
         "clean_default_sg_acl": false,
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
                     "direction": "inbound",
                     "name": "allow-all-network-inbound-1",
                     "source": "0.0.0.0/0",
                     "icmp": {
                             "type": 8
                        }
                  },
                  {
                     "action": "allow",
                     "destination": "0.0.0.0/0",
                     "direction": "inbound",
                     "name": "allow-all-network-inbound-2",
                     "source": "0.0.0.0/0",
                     "udp": {
			                   "source_port_max": 65535,
			                   "source_port_min": 1,
                            "port_max": 443,
                            "port_min": 443
                        }
		  },
                  {
                     "action": "allow",
                     "destination": "0.0.0.0/0",
                     "direction": "inbound",
                     "name": "allow-all-network-inbound-3",
                     "source": "0.0.0.0/0",
                     "tcp": {
                            "source_port_max": 65535,
                            "source_port_min": 1,
                            "port_max": 992,
                            "port_min": 992
                        }
                  },
                  {
                     "action": "allow",
                     "destination": "0.0.0.0/0",
                     "direction": "inbound",
                     "name": "allow-all-network-inbound-4",
                     "source": "0.0.0.0/0",
                     "tcp": {
                            "source_port_max": 65535,
                            "source_port_min": 1,
                            "port_max": 22,
                            "port_min": 22
                        }
                  },
                  {
                     "action": "allow",
                     "destination": "0.0.0.0/0",
                     "direction": "inbound",
                     "name": "allow-all-network-inbound-5",
                     "source": "0.0.0.0/0",
                     "tcp": {
                            "source_port_max": 65535,
                            "source_port_min": 1,
                            "port_max": 10443,
                            "port_min": 10443
                        }
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
         "boot_volume_encryption_key_name": null,
         "image_name": "ibm-zos-2-5-s390x-dev-test-wazi-7",
         "machine_type": "mz2o-2x16",
         "name": "workload-server",
         "resource_group": "workload-rg",
         "security_group": {
            "name": "workload-sg",
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
                  "direction": "inbound",
                  "name": "allow-all-inbound",
                  "source": "0.0.0.0/0",
	          "tcp": {
                       "port_max": 22,
                       "port_min": 22
                     }
              },
              {
                  "direction": "inbound",
                  "name": "allow-all-inbound-3",
                  "source": "0.0.0.0/0",
                  "icmp": {
                           "type": 8,
                           "code": 0
                         }
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
