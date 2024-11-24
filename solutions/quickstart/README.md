# Wazi as a service VSI on VPC Landing zone - QuickStart variation

![Architecture diagram for the QuickStart variation of VSI on VPC landing zone](https://raw.githubusercontent.com/terraform-ibm-modules/terraform-ibm-zvsi/main/reference-architecture/QuickStart.svg)

This pattern deploys the following infrastructure:

- Workload VPC with Wazi as a Service VSI with Floating IP.

## Customize your environment

You can customize your environment with VSI on VPC IBM Secure Landing Zone by using the `override_json_string` variable

### Customizing by using the `override_json_string` variable

We can use the `override_json_string` variable to create a fully customized environment based on the starting template. By default, Quickstart variation `override_json_string` variable is set to contain the default environment configuration. Each value in `override_json_string` variable corresponds directly to a variable value from this root module, which Quickstart variation uses to create your environment.

#### Supported variables

Through the `override_json_string` variable, you can pass any variable or supported optional variable attributes from this root module, which Quickstart variation uses to provision infrastructure. For a complete list of supported variables and attributes, see the [variables.tf ](variables.tf) file.

#### Overriding variables

You can redirect the contents between the output lines by running the following commands:

```sh
config = <<EOT
EOT
```

After you replace the contents of the `override_json_string` variable with your configuration, you can edit the resources within. For example, within the `variables.tf` file.

To view your current configuration, run the `terraform refresh` command.

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
### Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.3 |
| <a name="requirement_ibm"></a> [ibm](#requirement\_ibm) | 1.71.2 |

### Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_landing_zone"></a> [landing\_zone](#module\_landing\_zone) | terraform-ibm-modules/landing-zone/ibm//patterns//vsi//module | 6.0.4 |

### Resources

| Name | Type |
|------|------|
| [ibm_is_instance_volume_attachment.vsi](https://registry.terraform.io/providers/IBM-Cloud/ibm/1.71.2/docs/resources/is_instance_volume_attachment) | resource |
| [ibm_is_security_group_rule.workload_security_group_inbound](https://registry.terraform.io/providers/IBM-Cloud/ibm/1.71.2/docs/resources/is_security_group_rule) | resource |
| [ibm_is_instance.wazi](https://registry.terraform.io/providers/IBM-Cloud/ibm/1.71.2/docs/data-sources/is_instance) | data source |
| [ibm_is_security_group.workload](https://registry.terraform.io/providers/IBM-Cloud/ibm/1.71.2/docs/data-sources/is_security_group) | data source |

### Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_data_volume_names"></a> [data\_volume\_names](#input\_data\_volume\_names) | Enter the details of Data Volume creation. Refer https://github.com/terraform-ibm-modules/terraform-ibm-zvsi/tree/main/solutions/quickstart/README.md for input value | <pre>list(object({<br/>    name        = string<br/>    capacity    = number<br/>    volume_name = string<br/>  }))</pre> | `[]` | no |
| <a name="input_ibmcloud_api_key"></a> [ibmcloud\_api\_key](#input\_ibmcloud\_api\_key) | The IBM Cloud platform API key needed to deploy IAM enabled resources. | `string` | n/a | yes |
| <a name="input_image_name"></a> [image\_name](#input\_image\_name) | Enter a valid image name for Wazi VSI | `string` | `"ibm-zos-3-1-s390x-dev-test-wazi-1"` | no |
| <a name="input_machine_type"></a> [machine\_type](#input\_machine\_type) | input machine type: valid values are: bz2-4x16, bz2-8x32, bz2-16x64, cz2-8x16, cz2-16x32, mz2-2x16, mz2-4x32, mz2-8x64, mz2-16x128 | `string` | `"mz2-2x16"` | no |
| <a name="input_override_json_string"></a> [override\_json\_string](#input\_override\_json\_string) | Override default values with custom JSON. Any value here other than an empty string will override all other configuration changes. | `string` | `"{\n   \"atracker\": {\n      \"collector_bucket_name\": \"\",\n      \"receive_global_events\": false,\n      \"resource_group\": \"\",\n      \"add_route\": false\n   },\n   \"clusters\": [],\n   \"cos\": [],\n   \"enable_transit_gateway\": false,\n   \"transit_gateway_global\": false,\n   \"key_management\": {\n        \"keys\": [\n        ],\n        \"name\": null,\n        \"resource_group\": null,\n        \"use_hs_crypto\": false,\n        \"use_data\": false\n   },\n   \"network_cidr\": \"10.0.0.0/8\",\n   \"resource_groups\": [\n      {\n         \"create\": true,\n         \"name\": \"workload-rg\",\n         \"use_prefix\": true\n      }\n   ],\n   \"security_groups\": [],\n   \"transit_gateway_connections\": [],\n   \"transit_gateway_resource_group\": \"\",\n   \"virtual_private_endpoints\": [],\n   \"vpcs\": [\n      {\n         \"default_security_group_name\": \"workload-vpc-sg\",\n         \"default_security_group_rules\": [\n\t   {\n                  \"direction\": \"inbound\",\n                  \"name\": \"allow-ibm-inbound\",\n                  \"remote\": \"0.0.0.0/0\",\n                  \"tcp\": {\n                            \"port_max\": 22,\n                            \"port_min\": 22\n                        }\n\t   },\n\t   {\n                  \"direction\": \"inbound\",\n                  \"name\": \"allow-ibm-inbound-1\",\n                  \"remote\": \"0.0.0.0/0\",\n                  \"icmp\": {\n                            \"type\": 8\n                        }\n            },\n\t    {\n                  \"direction\": \"inbound\",\n                  \"name\": \"allow-ibm-inbound-2\",\n                  \"remote\": \"0.0.0.0/0\",\n                     \"udp\": {\n                            \"port_max\": 443,\n                            \"port_min\": 443\n                        }\n           }\n\t ],\n         \"clean_default_sg_acl\": false,\n         \"flow_logs_bucket_name\": null,\n         \"network_acls\": [\n            {\n               \"add_cluster_rules\": false,\n               \"name\": \"workload-acl\",\n               \"rules\": [\n                  {\n                     \"action\": \"allow\",\n                     \"destination\": \"10.0.0.0/8\",\n                     \"direction\": \"inbound\",\n                     \"name\": \"allow-ibm-inbound\",\n                     \"source\": \"161.26.0.0/16\"\n                  },\n                  {\n                     \"action\": \"allow\",\n                     \"destination\": \"10.0.0.0/8\",\n                     \"direction\": \"inbound\",\n                     \"name\": \"allow-all-network-inbound\",\n                     \"source\": \"10.0.0.0/8\"\n                  },\n                  {\n                     \"action\": \"allow\",\n                     \"destination\": \"0.0.0.0/0\",\n                     \"direction\": \"inbound\",\n                     \"name\": \"allow-all-network-inbound-1\",\n                     \"source\": \"0.0.0.0/0\",\n                     \"icmp\": {\n                             \"type\": 8\n                        }\n                  },\n                  {\n                     \"action\": \"allow\",\n                     \"destination\": \"0.0.0.0/0\",\n                     \"direction\": \"inbound\",\n                     \"name\": \"allow-all-network-inbound-2\",\n                     \"source\": \"0.0.0.0/0\",\n                     \"udp\": {\n\t\t\t                   \"source_port_max\": 65535,\n\t\t\t                   \"source_port_min\": 1,\n                            \"port_max\": 443,\n                            \"port_min\": 443\n                        }\n\t\t  },\n                  {\n                     \"action\": \"allow\",\n                     \"destination\": \"0.0.0.0/0\",\n                     \"direction\": \"inbound\",\n                     \"name\": \"allow-all-network-inbound-3\",\n                     \"source\": \"0.0.0.0/0\",\n                     \"tcp\": {\n                            \"source_port_max\": 65535,\n                            \"source_port_min\": 1,\n                            \"port_max\": 992,\n                            \"port_min\": 992\n                        }\n                  },\n                  {\n                     \"action\": \"allow\",\n                     \"destination\": \"0.0.0.0/0\",\n                     \"direction\": \"inbound\",\n                     \"name\": \"allow-all-network-inbound-4\",\n                     \"source\": \"0.0.0.0/0\",\n                     \"tcp\": {\n                            \"source_port_max\": 65535,\n                            \"source_port_min\": 1,\n                            \"port_max\": 22,\n                            \"port_min\": 22\n                        }\n                  },\n                  {\n                     \"action\": \"allow\",\n                     \"destination\": \"0.0.0.0/0\",\n                     \"direction\": \"inbound\",\n                     \"name\": \"allow-all-network-inbound-5\",\n                     \"source\": \"0.0.0.0/0\",\n                     \"tcp\": {\n                            \"source_port_max\": 65535,\n                            \"source_port_min\": 1,\n                            \"port_max\": 10443,\n                            \"port_min\": 10443\n                        }\n                  },\n                  {\n                     \"action\": \"allow\",\n                     \"destination\": \"0.0.0.0/0\",\n                     \"direction\": \"outbound\",\n                     \"name\": \"allow-all-outbound\",\n                     \"source\": \"0.0.0.0/0\"\n                  }\n               ]\n            }\n         ],\n         \"prefix\": \"workload\",\n         \"resource_group\": \"workload-rg\",\n         \"subnets\": {\n            \"zone-1\": [\n               {\n                  \"acl_name\": \"workload-acl\",\n                  \"cidr\": \"10.40.10.0/24\",\n                  \"name\": \"vsi-zone-1\",\n                  \"public_gateway\": false\n               }\n            ],\n            \"zone-2\": [],\n            \"zone-3\": []\n         },\n         \"use_public_gateways\": {\n            \"zone-1\": false,\n            \"zone-2\": false,\n            \"zone-3\": false\n         },\n         \"address_prefixes\": {\n            \"zone-1\": [],\n            \"zone-2\": [],\n            \"zone-3\": []\n         }\n      }\n   ],\n   \"vpn_gateways\": [],\n   \"vsi\": [\n      {\n         \"boot_volume_encryption_key_name\": null,\n         \"image_name\": \"ibm-zos-3-1-s390x-dev-test-wazi-1\",\n         \"machine_type\": \"mz2o-2x16\",\n         \"name\": \"workload-server\",\n         \"resource_group\": \"workload-rg\",\n         \"security_group\": {\n            \"name\": \"workload-sg\",\n            \"rules\": [\n               {\n                  \"direction\": \"inbound\",\n                  \"name\": \"allow-ibm-inbound\",\n                  \"source\": \"161.26.0.0/16\"\n               },\n               {\n                  \"direction\": \"inbound\",\n                  \"name\": \"allow-vpc-inbound\",\n                  \"source\": \"10.0.0.0/8\"\n               },\n               {\n                  \"direction\": \"inbound\",\n                  \"name\": \"allow-all-inbound\",\n                  \"source\": \"0.0.0.0/0\",\n\t          \"tcp\": {\n                       \"port_max\": 22,\n                       \"port_min\": 22\n                     }\n              },\n              {\n                  \"direction\": \"inbound\",\n                  \"name\": \"allow-all-inbound-3\",\n                  \"source\": \"0.0.0.0/0\",\n                  \"icmp\": {\n                           \"type\": 8,\n                           \"code\": 0\n                         }\n              },\n              {\n                 \"direction\": \"outbound\",\n                 \"name\": \"allow-all-outbound\",\n                 \"source\": \"0.0.0.0/0\"\n              }\n            ]\n         },\n         \"ssh_keys\": [\n            \"ssh-key\"\n         ],\n         \"subnet_names\": [\n            \"vsi-zone-1\"\n         ],\n         \"vpc_name\": \"workload\",\n         \"vsi_per_subnet\": 1,\n         \"enable_floating_ip\": true\n      }\n   ]\n}\n"` | no |
| <a name="input_ports"></a> [ports](#input\_ports) | Enter the list of ports to open for Wazi VSI SG. For example : [992,10443] | `list(number)` | <pre>[<br/>  21,<br/>  992,<br/>  9443,<br/>  10443,<br/>  8101,<br/>  8102,<br/>  8120,<br/>  8121,<br/>  8150,<br/>  8153,<br/>  8154,<br/>  8155,<br/>  8180,<br/>  8135,<br/>  8191,<br/>  8192,<br/>  8194,<br/>  8137,<br/>  8138,<br/>  8139,<br/>  8115,<br/>  8195,<br/>  12000,<br/>  12001,<br/>  12002,<br/>  12003,<br/>  12004,<br/>  12005,<br/>  12006,<br/>  12007,<br/>  12008,<br/>  12009,<br/>  12010,<br/>  12011,<br/>  12012,<br/>  12013,<br/>  12014,<br/>  12015,<br/>  12016,<br/>  12017,<br/>  12018,<br/>  12019,<br/>  12020,<br/>  12021,<br/>  12022,<br/>  12023,<br/>  12024,<br/>  12025,<br/>  12026,<br/>  12027,<br/>  12028,<br/>  12029<br/>]</pre> | no |
| <a name="input_prefix"></a> [prefix](#input\_prefix) | A unique identifier for resources. Must begin with a lowercase letter and end with a lowerccase letter or number. This prefix will be prepended to any resources provisioned by this template. Prefixes must be 16 or fewer characters. | `string` | n/a | yes |
| <a name="input_region"></a> [region](#input\_region) | Region where VPC will be created. To find your VPC region, use `ibmcloud is regions` command to find available regions. | `string` | n/a | yes |
| <a name="input_ssh_key"></a> [ssh\_key](#input\_ssh\_key) | A public SSH Key for VSI creation which does not already exist in the deployment region. Must be an RSA key with a key size of either 2048 bits or 4096 bits (recommended) - See https://cloud.ibm.com/docs/vpc?topic=vpc-ssh-keys. | `string` | n/a | yes |

### Outputs

| Name | Description |
|------|-------------|
| <a name="output_config"></a> [config](#output\_config) | Output configuration as encoded JSON |
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->

### List of all ports
List of all default ports added to Quickstar & Standard variations are documented here : https://www.ibm.com/docs/en/wazi-aas/1.0.0?topic=vpc-configurations-in-zos-stock-images#stock-image-configurations

<!-- Leave this section as is so that your module has a link to local development environment set up steps for contributors to follow -->
## Contributing

You can report issues and request features for this module in GitHub issues in the module repo. See [Report an issue or request a feature](https://github.com/terraform-ibm-modules/.github/blob/main/.github/SUPPORT.md).

To set up your local development environment, see [Local development setup](https://terraform-ibm-modules.github.io/documentation/#/local-dev-setup) in the project documentation.
