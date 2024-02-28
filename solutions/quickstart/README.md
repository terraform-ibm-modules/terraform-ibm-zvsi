# VSI on VPC IBM Secure Landing Zone - QuickStart Variation

[![Graduated (Supported)](https://img.shields.io/badge/status-Graduated%20(Supported)-brightgreen?style=plastic)](https://terraform-ibm-modules.github.io/documentation/#/badge-status)
[![semantic-release](https://img.shields.io/badge/%20%20%F0%9F%93%A6%F0%9F%9A%80-semantic--release-e10079.svg)](https://github.com/semantic-release/semantic-release)
[![pre-commit](https://img.shields.io/badge/pre--commit-enabled-brightgreen?logo=pre-commit&logoColor=white)](https://github.com/pre-commit/pre-commit)
[![latest release](https://img.shields.io/github/v/release/terraform-ibm-modules/terraform-ibm-zvsi?logo=GitHub&sort=semver)](https://github.com/terraform-ibm-modules/terraform-ibm-zvsi/releases/latest)
[![Renovate enabled](https://img.shields.io/badge/renovate-enabled-brightgreen.svg)](https://renovatebot.com/)

![Architecture diagram for the QuickStart variation of VSI on VPC landing zone](https://raw.githubusercontent.com/terraform-ibm-modules/terraform-ibm-zvsi/standard_quickstart/reference-architecture/QuickStart.svg)

This pattern deploys the following infrastructure:

- Workload VPC with Wazi as a Service VSI with Floating IP.

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Customize your environment

You can customize your environment with VSI on VPC IBM Secure Landing Zone by using the `override_json_string` variable

### Customizing by using the `override_json_string` variable

The second route is to use the `override_json_string` variable to create a fully customized environment based on the starting template. By default, Quickstart variation `override_json_string` variable is set to contain the default environment configuration. Each value in `override_json_string` variable corresponds directly to a variable value from this root module, which Quickstart variation uses to create your environment.

#### Supported variables

Through the `override_json_string` variable, you can pass any variable or supported optional variable attributes from this root module, which Quickstart variation uses to provision infrastructure. For a complete list of supported variables and attributes, see the [variables.tf ](variables.tf) file.

#### Overriding variables

After every execution of `terraform apply`, a JSON-encoded definition is output. This definition of your environment is based on the defaults for the VSI on VPC IBM Secure Landing Zone and any variables that are changed in the `override_json_string` variable. You can then use the output in the `override_json_string` variable.

You can redirect the contents between the output lines by running the following commands:

```sh
config = <<EOT
EOT
```

After you replace the contents of the `override_json_string` variable with your configuration, you can edit the resources within. Make use that you set the template `override` variable to `true` as an input variable. For example, within the `variables.tf` file.

To view your current configuration, run the `terraform refresh` command.

#### Overriding only some variables

The `override_json_string` variable does not need to contain all elements. For example,

```json
{
  "enable_transit_gateway": false
}
```

### Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.3, < 1.6 |
| <a name="requirement_ibm"></a> [ibm](#requirement\_ibm) | >= 1.58.1 |

### Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_landing_zone"></a> [landing\_zone_](#module\_landing\_zone) | terraform-ibm-modules/landing-zone/ibm//patterns//vsi-quickstart | 4.13.0 |

### Execution

1. Export API Key
    export TF_VAR_ibmcloud_api_key=xxxx
2. Run Terraform init
3. Run Terraform apply

<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->

