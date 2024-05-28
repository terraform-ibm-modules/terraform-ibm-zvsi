# Wazi as a service VSI on VPC Landing zone - Standard Variation


![Architecture diagram for the Standard variation of VSI on VPC landing zone](https://raw.githubusercontent.com/terraform-ibm-modules/terraform-ibm-zvsi/main/reference-architecture/Standard-variation.svg)

This pattern deploys the following infrastructure:

- A resource group for cloud services and for each VPC.
- Cloud Object Storage instances for flow logs and Activity Tracker.
- Encryption keys in a Key Protect instance.
- A edge and workload VPC connected by a transit gateway.
- All necessary networking rules to allow communication.
- Virtual Private Endpoint (VPE) for Cloud Object Storage in each VPC.
- A client-to-site VPN gateway in the edge VPC.
- A jump server Bastion host VSI in the edge VPC without floating IP.
- A site-to-site VPN in the workload VPC.
- Wazi as a Service VSI in the workload VPC.

## Customize your environment

You can customize your environment with VSI on VPC IBM Secure Landing Zone by using the `override.json` file.

### Customizing by using the override.json file

The second route is to use the `override.json` to create a fully customized environment based on the starting template. By default, Standard variation `override.json` is set to contain the default environment configuration. You can use the `override.json` in the Standard variation directory by setting the template input `override` variable to `true`. Each value in `override.json` corresponds directly to a variable value from this root module, which Standard variation uses to create your environment.

#### Supported variables

Through the `override.json`, you can pass any variable or supported optional variable attributes from this root module, which Standard variation uses to provision infrastructure. For a complete list of supported variables and attributes, see the [variables.tf ](variables.tf) file.

#### Overriding variables

You can redirect the contents between the output lines by running the following commands:

```sh
config = <<EOT
EOT
```

After you replace the contents of the `override.json` file with your configuration, you can edit the resources within. Make use that you set the template `override` variable to `true` as an input variable.

#### Overriding only some variables

The `override.json` file does not need to contain all elements. For example,

```json
{
  "enable_transit_gateway": false
}
```
<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
### Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.3, < 1.7 |
| <a name="requirement_ibm"></a> [ibm](#requirement\_ibm) | 1.65.0 |
| <a name="requirement_time"></a> [time](#requirement\_time) | 0.11.1 |

### Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_client_to_site_sg"></a> [client\_to\_site\_sg](#module\_client\_to\_site\_sg) | terraform-ibm-modules/security-group/ibm | 2.6.1 |
| <a name="module_client_to_site_vpn"></a> [client\_to\_site\_vpn](#module\_client\_to\_site\_vpn) | terraform-ibm-modules/client-to-site-vpn/ibm | 1.7.2 |
| <a name="module_landing_zone"></a> [landing\_zone](#module\_landing\_zone) | terraform-ibm-modules/landing-zone/ibm//patterns//vsi//module | 5.22.0 |
| <a name="module_private_secret_engine"></a> [private\_secret\_engine](#module\_private\_secret\_engine) | terraform-ibm-modules/secrets-manager-private-cert-engine/ibm | 1.3.1 |
| <a name="module_resource_group"></a> [resource\_group](#module\_resource\_group) | terraform-ibm-modules/resource-group/ibm | 1.1.5 |
| <a name="module_secrets_manager"></a> [secrets\_manager](#module\_secrets\_manager) | terraform-ibm-modules/secrets-manager/ibm | 1.12.4 |
| <a name="module_secrets_manager_group"></a> [secrets\_manager\_group](#module\_secrets\_manager\_group) | terraform-ibm-modules/secrets-manager-secret-group/ibm | 1.2.1 |
| <a name="module_secrets_manager_private_certificate"></a> [secrets\_manager\_private\_certificate](#module\_secrets\_manager\_private\_certificate) | terraform-ibm-modules/secrets-manager-private-cert/ibm | 1.2.1 |

### Resources

<<<<<<< HEAD
| Name | Type |
|------|------|
| [ibm_is_instance_volume_attachment.example](https://registry.terraform.io/providers/IBM-Cloud/ibm/1.65.0/docs/resources/is_instance_volume_attachment) | resource |
| [ibm_is_security_group_rule.s2s_security_group_inbound](https://registry.terraform.io/providers/IBM-Cloud/ibm/1.65.0/docs/resources/is_security_group_rule) | resource |
| [ibm_is_security_group_rule.wazi_security_group_inbound](https://registry.terraform.io/providers/IBM-Cloud/ibm/1.65.0/docs/resources/is_security_group_rule) | resource |
| [time_sleep.wait_for_security_group](https://registry.terraform.io/providers/hashicorp/time/0.11.1/docs/resources/sleep) | resource |
| [ibm_is_instance.wazi](https://registry.terraform.io/providers/IBM-Cloud/ibm/1.65.0/docs/data-sources/is_instance) | data source |
| [ibm_is_security_group.workload_s2s](https://registry.terraform.io/providers/IBM-Cloud/ibm/1.65.0/docs/data-sources/is_security_group) | data source |
| [ibm_is_security_group.workload_wazi](https://registry.terraform.io/providers/IBM-Cloud/ibm/1.65.0/docs/data-sources/is_security_group) | data source |
| [ibm_is_subnet.edge_vpn](https://registry.terraform.io/providers/IBM-Cloud/ibm/1.65.0/docs/data-sources/is_subnet) | data source |
| [ibm_is_vpc.edge](https://registry.terraform.io/providers/IBM-Cloud/ibm/1.65.0/docs/data-sources/is_vpc) | data source |
=======
1. Export API Key
    export TF_VAR_ibmcloud_api_key=""
2. Run Terraform init
3. Run Terraform apply -var-file=override.json
4. Input value for additional storage.
  ```var.data_volume_names
  Enter the details of Data Volume creation
>>>>>>> 082729b74eca7ee21d72e38abeb899516639614a

### Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_access_group_name"></a> [access\_group\_name](#input\_access\_group\_name) | Name of the IAM Access Group to create if var.create\_policy is true | `string` | `"client-to-site-vpn-access-group"` | no |
| <a name="input_cert_common_name"></a> [cert\_common\_name](#input\_cert\_common\_name) | Fully qualified domain name or host domain name for the private certificate to be created | `string` | n/a | yes |
| <a name="input_certificate_template_name"></a> [certificate\_template\_name](#input\_certificate\_template\_name) | Name of the Certificate Template to create for a private\_cert secret engine. When var.existing\_sm\_instance\_guid is true, then it has to be the existing template name that exists in the private cert engine. | `string` | `"my-template"` | no |
| <a name="input_create_policy"></a> [create\_policy](#input\_create\_policy) | Set to true to create a new access group (using the value of var.access\_group\_name) with a VPN Client role | `bool` | `true` | no |
| <a name="input_data_volume_names"></a> [data\_volume\_names](#input\_data\_volume\_names) | Enter the details of Data Volume creation. Refer https://github.com/terraform-ibm-modules/terraform-ibm-zvsi/tree/main/solutions/standard/README.md for input value | <pre>list(object({<br>    name        = string<br>    capacity    = number<br>    volume_name = string<br>  }))</pre> | `[]` | no |
| <a name="input_ibmcloud_api_key"></a> [ibmcloud\_api\_key](#input\_ibmcloud\_api\_key) | The IBM Cloud platform API key needed to deploy IAM enabled resources. | `string` | n/a | yes |
| <a name="input_image_name"></a> [image\_name](#input\_image\_name) | Enter a valid image name for Wazi VSI | `string` | `"ibm-zos-3-1-s390x-dev-test-wazi-1"` | no |
| <a name="input_intermediate_ca_name"></a> [intermediate\_ca\_name](#input\_intermediate\_ca\_name) | Name of the Intermediate CA to create for a private\_cert secret engine. Only used when var.existing\_sm\_instance\_guid is false | `string` | `"intermediate-ca"` | no |
| <a name="input_machine_type"></a> [machine\_type](#input\_machine\_type) | input machine type: valid values are: bz2-4x16, bz2-8x32, bz2-16x64, cz2-8x16, cz2-16x32, mz2-2x16, mz2-4x32, mz2-8x64, mz2-16x128 | `string` | `"mz2-2x16"` | no |
| <a name="input_override"></a> [override](#input\_override) | Override default values with custom JSON template. This uses the file `override.json` to allow users to create a fully customized environment. | `bool` | `true` | no |
| <a name="input_ports"></a> [ports](#input\_ports) | Enter the list of ports to open for Wazi VSI SG. | `list(number)` | <pre>[<br>  21,<br>  992,<br>  9443,<br>  10443,<br>  8101,<br>  8102,<br>  8120,<br>  8121,<br>  8150,<br>  8153,<br>  8154,<br>  8155,<br>  8180,<br>  8135,<br>  8191,<br>  8192,<br>  8194,<br>  8137,<br>  8138,<br>  8139,<br>  8115,<br>  8195,<br>  12000,<br>  12001,<br>  12002,<br>  12003,<br>  12004,<br>  12005,<br>  12006,<br>  12007,<br>  12008,<br>  12009,<br>  12010,<br>  12011,<br>  12012,<br>  12013,<br>  12014,<br>  12015,<br>  12016,<br>  12017,<br>  12018,<br>  12019,<br>  12020,<br>  12021,<br>  12022,<br>  12023,<br>  12024,<br>  12025,<br>  12026,<br>  12027,<br>  12028,<br>  12029<br>]</pre> | no |
| <a name="input_prefix"></a> [prefix](#input\_prefix) | A unique identifier for resources. Must begin with a lowercase letter and end with a lowerccase letter or number. This prefix will be prepended to any resources provisioned by this template. Prefixes must be 16 or fewer characters. | `string` | n/a | yes |
| <a name="input_region"></a> [region](#input\_region) | Region where all the resources will be created. Use `ibmcloud is regions` command to find available regions. | `string` | n/a | yes |
| <a name="input_root_ca_common_name"></a> [root\_ca\_common\_name](#input\_root\_ca\_common\_name) | Fully qualified domain name or host domain name for the certificate to be created | `string` | `"cloud.ibm.com"` | no |
| <a name="input_root_ca_max_ttl"></a> [root\_ca\_max\_ttl](#input\_root\_ca\_max\_ttl) | Maximum TTL value for the root CA | `string` | `"8760h"` | no |
| <a name="input_root_ca_name"></a> [root\_ca\_name](#input\_root\_ca\_name) | Name of the Root CA to create for a private\_cert secret engine. Only used when var.existing\_sm\_instance\_guid is false | `string` | `"root-ca"` | no |
| <a name="input_sm_service_plan"></a> [sm\_service\_plan](#input\_sm\_service\_plan) | Type of service plan to use to provision Secrets Manager if not using an existing one. | `string` | `"trial"` | no |
| <a name="input_ssh_public_key"></a> [ssh\_public\_key](#input\_ssh\_public\_key) | A public SSH Key for VSI creation which does not already exist in the deployment region. Must be an RSA key with a key size of either 2048 bits or 4096 bits (recommended) - See https://cloud.ibm.com/docs/vpc?topic=vpc-ssh-keys. To use an existing key, enter a value for the variable 'existing\_ssh\_key\_name' instead. | `string` | n/a | yes |
| <a name="input_vpn_client_access_group_users"></a> [vpn\_client\_access\_group\_users](#input\_vpn\_client\_access\_group\_users) | List of users in the Client to Site VPN Access Group | `list(string)` | `[]` | no |
| <a name="input_vpn_server_routes"></a> [vpn\_server\_routes](#input\_vpn\_server\_routes) | Map of server routes to be added to created VPN server. | <pre>map(object({<br>    destination = string<br>    action      = string<br>  }))</pre> | <pre>{<br>  "route-vpn-2-dns": {<br>    "action": "translate",<br>    "destination": "161.26.0.0/24"<br>  },<br>  "route-vpn-2-services": {<br>    "action": "translate",<br>    "destination": "166.9.0.0/16"<br>  },<br>  "vpn-ibm-network": {<br>    "action": "translate",<br>    "destination": "10.0.0.0/8"<br>  }<br>}</pre> | no |

### Outputs

| Name | Description |
|------|-------------|
| <a name="output_config"></a> [config](#output\_config) | Output configuration as encoded JSON |
| <a name="output_cos_bucket_data"></a> [cos\_bucket\_data](#output\_cos\_bucket\_data) | List of data for COS buckets created |
| <a name="output_cos_data"></a> [cos\_data](#output\_cos\_data) | List of Cloud Object Storage instance data |
| <a name="output_key_management_crn"></a> [key\_management\_crn](#output\_key\_management\_crn) | CRN for KMS instance |
| <a name="output_key_management_guid"></a> [key\_management\_guid](#output\_key\_management\_guid) | GUID for KMS instance |
| <a name="output_key_management_name"></a> [key\_management\_name](#output\_key\_management\_name) | Name of key management service |
| <a name="output_key_map"></a> [key\_map](#output\_key\_map) | Map of ids and keys for keys created |
| <a name="output_key_rings"></a> [key\_rings](#output\_key\_rings) | Key rings created by module |
| <a name="output_prefix"></a> [prefix](#output\_prefix) | The prefix that is associated with all resources |
| <a name="output_resource_group_data"></a> [resource\_group\_data](#output\_resource\_group\_data) | List of resource groups data used within landing zone. |
| <a name="output_resource_group_names"></a> [resource\_group\_names](#output\_resource\_group\_names) | List of resource groups names used within landing zone. |
| <a name="output_schematics_workspace_id"></a> [schematics\_workspace\_id](#output\_schematics\_workspace\_id) | ID of the IBM Cloud Schematics workspace. Returns null if not ran in Schematics |
| <a name="output_ssh_key_data"></a> [ssh\_key\_data](#output\_ssh\_key\_data) | List of SSH key data |
| <a name="output_ssh_public_key"></a> [ssh\_public\_key](#output\_ssh\_public\_key) | The string value of the ssh public key |
| <a name="output_subnet_data"></a> [subnet\_data](#output\_subnet\_data) | List of Subnet data created |
| <a name="output_transit_gateway_data"></a> [transit\_gateway\_data](#output\_transit\_gateway\_data) | Created transit gateway data |
| <a name="output_transit_gateway_name"></a> [transit\_gateway\_name](#output\_transit\_gateway\_name) | The name of the transit gateway |
| <a name="output_vpc_data"></a> [vpc\_data](#output\_vpc\_data) | List of VPC data |
| <a name="output_vpc_names"></a> [vpc\_names](#output\_vpc\_names) | A list of the names of the VPC |
| <a name="output_vpc_resource_list"></a> [vpc\_resource\_list](#output\_vpc\_resource\_list) | List of VPC with VSI and Cluster deployed on the VPC. |
| <a name="output_vpn_data"></a> [vpn\_data](#output\_vpn\_data) | List of VPN data |
| <a name="output_vsi_list"></a> [vsi\_list](#output\_vsi\_list) | A list of VSI with name, id, zone, and primary ipv4 address, VPC Name, and floating IP. |
| <a name="output_vsi_names"></a> [vsi\_names](#output\_vsi\_names) | A list of the vsis names provisioned within the VPCs |
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->

### List of all ports
List of all default ports added to Quickstar & Standard variations are documented here : https://www.ibm.com/docs/en/wazi-aas/1.0.0?topic=vpc-configurations-in-zos-stock-images#stock-image-configurations

<!-- Leave this section as is so that your module has a link to local development environment set up steps for contributors to follow -->
## Contributing

You can report issues and request features for this module in GitHub issues in the module repo. See [Report an issue or request a feature](https://github.com/terraform-ibm-modules/.github/blob/main/.github/SUPPORT.md).

To set up your local development environment, see [Local development setup](https://terraform-ibm-modules.github.io/documentation/#/local-dev-setup) in the project documentation.
