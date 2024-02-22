<!-- BEGIN MODULE HOOK -->

![Architecture diagram for the Standard variation of VSI on VPC landing zone]((https://raw.githubusercontent.com/terraform-ibm-zvsi/blob/init-standard-variation-v1/reference-architecture/Standard-variation.svg)

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

You can customize your environment with Secure Landing Zone by using the `override.json` file.

### Customizing by using the override.json file

The second route is to use the `override.json` to create a fully customized environment based on the starting template. By default, each pattern's `override.json` is set to contain the default environment configuration. You can use the `override.json` in the respective pattern directory by setting the template input `override` variable to `true`. Each value in `override.json` corresponds directly to a variable value from this root module, which each pattern uses to create your environment.

#### Supported variables

Through the `override.json`, you can pass any variable or supported optional variable attributes from this root module, which each pattern uses to provision infrastructure. For a complete list of supported variables and attributes, see the [variables.tf ](variables.tf) file.

#### Overriding variables

After every execution of `terraform apply`, a JSON-encoded definition is output. This definition of your environment is based on the defaults for the Landing Zone and any variables that are changed in the `override.json` file. You can then use the output in the `override.json` file.

You can redirect the contents between the output lines by running the following commands:

```sh
config = <<EOT
EOT
```

After you replace the contents of the `override.json` file with your configuration, you can edit the resources within. Make use that you set the template `override` variable to `true` as an input variable. For example, within the `variables.tf` file.

Locally run configurations do not require a Terraform `apply` command to generate the `override.json`. To view your current configuration, run the `terraform refresh` command.

#### Overriding only some variables

The `override.json` file does not need to contain all elements. For example,

```json
{
  "enable_transit_gateway": false
}
```

<!-- END MODULE HOOK -->

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
### Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.3, < 1.6 |
| <a name="requirement_ibm"></a> [ibm](#requirement\_ibm) | >= 1.56.1 |

### Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_landing-zone"></a> [landing\_zone](#module\_landing\_zone) | terraform-ibm-modules/landing-zone/ibm//patterns//vsi//module | 4.13.0 |
| <a name="module_resource_group"></a> [resource\_group](#module\_resource\_group) | terraform-ibm-modules/resource-group/ibm | 1.0.6 |
| <a name="module_secrets_manager"></a> [secrets\_manager](#module\_secrets\_manager) | terraform-ibm-modules/secrets-manager/ibm | 1.1.0 |
| <a name="module_secrets_manager_group"></a> [secrets\_manager\_group](#module\_secrets\_manager\_group) | terraform-ibm-modules/secrets-manager-secret-group/ibm | 1.0.1 |
| <a name="module_private_secret_engine"></a> [private\_secret\_engine](#module\_private\_secret\_engine) | terraform-ibm-modules/secrets-manager-private-cert-engine/ibm | 1.1.1 |
| <a name="module_secrets_manager_private_certificate"></a> [secrets\_manager\_private\_certificate](#module\_secrets\_manager\_private\_certificate) | terraform-ibm-modules/secrets-manager-private-cert/ibm | 1.0.2 |
| <a name="module_client_to_site_vpn"></a> [client\_to\_site\_vpn](#module\_client\_to\_site\_vpn) | terraform-ibm-modules/client-to-site-vpn/ibm | 1.6.2 |

<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->


