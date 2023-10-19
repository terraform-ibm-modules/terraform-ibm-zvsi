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
  description = "Region where VPC will be created. To find your VPC region, use `ibmcloud is regions` command to find available regions."
  type        = string
}
variable "ssh_public_key" {
  description = "A public SSH Key for VSI creation which does not already exist in the deployment region. Must be an RSA key with a key size of either 2048 bits or 4096 bits (recommended) - See https://cloud.ibm.com/docs/vpc?topic=vpc-ssh-keys. To use an existing key, enter a value for the variable 'existing_ssh_key_name' instead."
  type        = string
  validation {
    error_message = "Public SSH Key must be a valid ssh rsa public key."
    condition     = var.ssh_public_key == null || can(regex("ssh-rsa AAAA[0-9A-Za-z+/]+[=]{0,3} ?([^@]+@[^@]+)?", var.ssh_public_key))
  }
}

variable "override_json_string" {
  description = "Override default values with custom JSON. Any value here other than an empty string will override all other configuration changes."
  type        = string
  default     = <<EOF
	{
   "atracker": {
      "collector_bucket_name": "atracker-bucket",
      "receive_global_events": true,
      "resource_group": "service-rg",
      "add_route": true
   },
   "clusters": [],
   "cos": [
   {
            "buckets": [
                {
                    "endpoint_type": "public",
                    "force_delete": true,
                    "kms_key": "slz-atracker-key",
                    "name": "atracker-bucket",
                    "storage_class": "standard"
                }
            ],
            "keys": [
                {
                    "name": "cos-bind-key",
                    "role": "Writer",
                    "enable_HMAC": false
                }
            ],
            "name": "atracker-cos",
            "plan": "standard",
            "resource_group": "service-rg",
            "use_data": false
        },
        {
            "buckets": [
                {
                    "endpoint_type": "public",
                    "force_delete": true,
                    "kms_key": "slz-slz-key",
                    "name": "management-bucket",
                    "storage_class": "standard"
                },
                {
                    "endpoint_type": "public",
                    "force_delete": true,
                    "kms_key": "slz-slz-key",
                    "name": "workload-bucket",
                    "storage_class": "standard"
                }
            ],
            "keys": [],
            "name": "cos",
            "plan": "standard",
            "resource_group": "service-rg",
            "use_data": false
        } 
   ],
   "enable_transit_gateway": true,
   "transit_gateway_global": false,
   "key_management": {
        "keys": [
            {
                "key_ring": "slz-slz-ring",
                "name": "slz-slz-key",
                "root_key": true
            },
            {
                "key_ring": "slz-slz-ring",
                "name": "slz-atracker-key",
                "root_key": true
            },
            {
                "key_ring": "slz-slz-ring",
                "name": "slz-vsi-volume-key",
                "root_key": true
            }
	],
        "name": "slz-keys",
        "resource_group": "service-rg",
        "use_hs_crypto": false,
        "use_data": false
   },
   "network_cidr": "10.0.0.0/8",
   "resource_groups": [
      {
         "create": true,
         "name": "management-rg",
         "use_prefix": true
      },
      {
         "create": true,
         "name": "workload-rg",
         "use_prefix": true
      },
      {
         "create": true,
         "name": "service-rg",
         "use_prefix": true
      }
   ],
   "security_groups": [],
   "transit_gateway_connections": [
     "management",
     "workload"
   ],
   "transit_gateway_resource_group": "service-rg",
   "virtual_private_endpoints": [
     {
            "service_name": "cos",
            "service_type": "cloud-object-storage",
            "resource_group": "service-rg",
            "vpcs": [
                {
                    "name": "management",
                    "subnets": [
                        "vpe-zone-1",
                        "vpe-zone-2",
                        "vpe-zone-3"
                    ]
                },
                {
                    "name": "workload",
                    "subnets": [
                        "vpe-zone-1",
                        "vpe-zone-2",
                        "vpe-zone-3"
                    ]
                }
            ]
        } 
   ],
   "vpcs": [
      {
         "default_security_group_rules": [],
         "clean_default_sg_acl": true,
         "flow_logs_bucket_name": "management-bucket",
         "network_acls": [
            {
               "add_cluster_rules": false,
               "name": "management-acl",
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
         "prefix": "management",
         "resource_group": "management-rg",
         "subnets": {
            "zone-1": [
               {
                  "acl_name": "management-acl",
                  "cidr": "10.40.10.0/24",
                  "name": "vsi-zone-1",
                  "public_gateway": false
               },
          {
                        "acl_name": "management-acl",
                        "cidr": "10.10.20.0/24",
                        "name": "vpe-zone-1",
                        "public_gateway": false
                    },
                    {
                        "acl_name": "management-acl",
                        "cidr": "10.10.30.0/24",
                        "name": "vpn-zone-1",
                        "public_gateway": false
                    }
                ],
                "zone-2": [
                    {
                        "acl_name": "management-acl",
                        "cidr": "10.20.10.0/24",
                        "name": "vsi-zone-2",
                        "public_gateway": false
                    },
                    {
                        "acl_name": "management-acl",
                        "cidr": "10.20.20.0/24",
                        "name": "vpe-zone-2",
                        "public_gateway": false
                    }
                ],
                "zone-3": [
                    {
                        "acl_name": "management-acl",
                        "cidr": "10.30.10.0/24",
                        "name": "vsi-zone-3",
                        "public_gateway": false
                    },
                    {
                        "acl_name": "management-acl",
                        "cidr": "10.30.20.0/24",
                        "name": "vpe-zone-3",
                        "public_gateway": false
                    }
                ]    
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
      },
   {   
         "default_security_group_rules": [],
         "clean_default_sg_acl": true,
         "flow_logs_bucket_name": "workload-bucket",
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
               },
               {
                  "acl_name": "workload-acl",
                  "cidr": "10.40.20.0/24",
                  "name": "vpe-zone-1",
                  "public_gateway": false
               }
             ],
                "zone-2": [
                    {
                        "acl_name": "workload-acl",
                        "cidr": "10.50.10.0/24",
                        "name": "vsi-zone-2",
                        "public_gateway": false
                    },
                    {
                        "acl_name": "workload-acl",
                        "cidr": "10.50.20.0/24",
                        "name": "vpe-zone-2",
                        "public_gateway": false
                    }
                ],
                "zone-3": [
                    {
                        "acl_name": "workload-acl",
                        "cidr": "10.60.10.0/24",
                        "name": "vsi-zone-3",
                        "public_gateway": false
                    },
                    {
                        "acl_name": "workload-acl",
                        "cidr": "10.60.20.0/24",
                        "name": "vpe-zone-3",
                        "public_gateway": false
                    }
                ]
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
   "vpn_gateways": [
      {
            "connections": [],
            "name": "management-gateway",
            "resource_group": "management-rg",
            "subnet_name": "vpn-zone-1",
            "vpc_name": "management"
        }
   ],
   "vsi": [
      {
         "boot_volume_encryption_key_name": "slz-vsi-volume-key",
         "image_name": "ibm-zos-2-5-s390x-dev-test-wazi-4",
         "machine_type": "mz2-2x16",
         "name": "management-server",
         "resource_group": "management-rg",
         "security_group": {
            "name": "management",
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
            "vsi-zone-1",
            "vsi-zone-2",
            "vsi-zone-3"
         ],
         "vpc_name": "management",
         "vsi_per_subnet": 1,
         "enable_floating_ip": false
      },
      {
         "boot_volume_encryption_key_name": "slz-vsi-volume-key",
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
            "vsi-zone-1",
            "vsi-zone-2",
            "vsi-zone-3"
         ],
         "vpc_name": "workload",
         "vsi_per_subnet": 1,
         "enable_floating_ip": false
      }
   ]
}
EOF
}
