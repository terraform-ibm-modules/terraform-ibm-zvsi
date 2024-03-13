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
