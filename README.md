<!-- BEGIN MODULE HOOK -->

<!-- Update the title to match the module name and add a description -->
# Terraform Modules Template Project
<!-- UPDATE BADGE: Update the link for the following badge-->
[![Incubating (Not yet consumable)](https://img.shields.io/badge/status-Incubating%20(Not%20yet%20consumable)-red)](https://terraform-ibm-modules.github.io/documentation/#/badge-status)
[![pre-commit](https://img.shields.io/badge/pre--commit-enabled-brightgreen?logo=pre-commit&logoColor=white)](https://github.com/pre-commit/pre-commit)
[![latest release](https://img.shields.io/github/v/release/terraform-ibm-modules/terraform-ibm-zvsi?logo=GitHub&sort=semver)](https://github.com/terraform-ibm-modules/terraform-ibm-zvsi/releases)
[![Renovate enabled](https://img.shields.io/badge/renovate-enabled-brightgreen.svg)](https://renovatebot.com/)
[![semantic-release](https://img.shields.io/badge/%20%20%F0%9F%93%A6%F0%9F%9A%80-semantic--release-e10079.svg)](https://github.com/semantic-release/semantic-release)

<!-- Remove the content in this H2 heading after completing the steps -->

## Summary

This repository contains WaziaaS deployable architecture solutions that help provision VPC landing zones and interconnect them. The below solutions are available and can be deployed with terraform.

Two solutions are offered:
1. [Quickstart Variation](https://github.com/terraform-ibm-modules/terraform-ibm-zvsi/tree/main/solutions/quickstart)
    This pattern deploys the following infrastructure:
    - Workload VPC with Wazi as a service VSI.
    - Uses Floating IP addresses for access through the public internet.
2. [Standard Variation](https://github.com/terraform-ibm-modules/terraform-ibm-zvsi/tree/main/solutions/standard)
    This pattern deploys the following infrastructure:
    - Separate VPC for edge.
    - Separate VPC for workloads.
    - Virtual Server Instances for every subnet.
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
<!-- Remove the content in this previous H2 heading -->

<!-- BEGIN OVERVIEW HOOK -->
## Overview
* [terraform-ibm-zvi](#terraform-ibm-zvsi)
* [Variations](./solutions)
    * [Quickstart](./solutions/quickstart)
    * [Standard](./solutions/standard)
* [Contributing](#contributing)
<!-- END OVERVIEW HOOK -->

## Reference architectures
- [Quickstart Variation](https://github.com/terraform-ibm-modules/terraform-ibm-zvsi/tree/main/solutions/quickstart)
- [Standard Variation](https://github.com/terraform-ibm-modules/terraform-ibm-zvsi/tree/main/solutions/standard)
<!--
Add links to any reference architectures for this module.
(Usually in the `/reference-architectures` directory.)
See "Reference architecture" in Authoring Guidelines in the public documentation at
https://terraform-ibm-modules.github.io/documentation/#/implementation-guidelines?id=reference-architecture
-->

### Usage

<!--
Add an example of the use of the module in the following code block.

Use real values instead of "var.<var_name>" or other placeholder values
unless real values don't help users know what to change.
-->

```hcl

```

## Required IAM access policies

You need the following permissions to run this module.

- IAM Access Requirements
    - **Quickstart Variation**
        - Platform Roles
            - `Editor` Virtual Private Cloud
    - **Standard Variation**
        - Platform Roles
            - `Editor` IAM Identity Service
            - `Editor` Virtual Private Cloud
        - Service Roles
            - `Editor` Cloud Object Storage
            - `Editor` IBM Key Protect
<!-- END MODULE HOOK -->
<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
### Requirements

| Name | Version |
|------|---------|
| terraform | >= 1.3, < 1.6 |
| ibm | >= 1.56.1 |

### Modules

| Name | Source | Version |
|------|--------|---------|
| landing-zone | [terraform-ibm-modules/terraform-ibm-landing-zone/tree/main/patterns/vsi](https://github.com/terraform-ibm-modules/terraform-ibm-landing-zone/tree/main/patterns/vsi) | 4.13.0 |
| resource_group | [terraform-ibm-modules/terraform-ibm-resource-group](https://github.com/terraform-ibm-modules/terraform-ibm-resource-group) | 1.0.6 |
| secrets_manager | [terraform-ibm-modules/terraform-ibm-secrets-manager](https://github.com/terraform-ibm-modules/terraform-ibm-secrets-manager)| 1.1.0 |
| secrets_manager_group | [terraform-ibm-modules/terraform-ibm-secrets-manager-secret-group](https://github.com/terraform-ibm-modules/terraform-ibm-secrets-manager-secret-group) | 1.0.1 |
| private_secret_engine | [terraform-ibm-modules/terraform-ibm-secrets-manager-private-cert-engine](https://github.com/terraform-ibm-modules/terraform-ibm-secrets-manager-private-cert-engine)| 1.1.1 |
| secrets_manager_private_certificate | [terraform-ibm-modules/terraform-ibm-secrets-manager-private-cert](https://github.com/terraform-ibm-modules/terraform-ibm-secrets-manager-private-cert) | 1.0.2 |
| client_to_site_vpn | [terraform-ibm-modules/terraform-ibm-client-to-site-vpn](https://github.com/terraform-ibm-modules/terraform-ibm-client-to-site-vpn) | 1.6.2 |

### Resources

| Name | Type | Variation |
|------|------|-----------|
| [time_sleep](https://registry.terraform.io/providers/hashicorp/time/latest/docs/resources/sleep) | resource | standard |
| [ibm_is_subnet](https://registry.terraform.io/providers/IBM-Cloud/ibm/latest/docs/resources/is_subnet_reserved_ip) | data source | standard |
| [ibm_is_vpc](https://registry.terraform.io/providers/IBM-Cloud/ibm/latest/docs/resources/is_vpc_routing_table_route) | data source | standard |
| [ibm_is_security_group](https://registry.terraform.io/providers/IBM-Cloud/ibm/latest/docs/resources/is_security_group_rule) | data source | quickstart, standard |
| [ibm_is_security_group_rule](https://registry.terraform.io/providers/IBM-Cloud/ibm/latest/docs/resources/is_security_group_rule) | resource | quickstart, standard |


### Inputs

| Name | Description | Type | Default | Required | Variation |
|------|-------------|------|---------|:--------:|-----------|
| [IBM_Cloud_API_Key] | The IBM Cloud platform API key needed to deploy IAM enabled resources | `string` | unique | yes | quickstart, standard |
| [Machine_Type] | Valid machine type such as "mz2o-2x16", "bz2-4x16", "bz2-8x32", etc... | `string` | "mz2o-2x16" | yes | quickstart, standard |
| [Prefix] | A unique identifier for resources | `string` | n/a | yes | quickstart, standard |
| [Region] | Region where VPC will be created | `string` | n/a | yes | quickstart, standard |
| [SSH_Public_Key] | A public SSH Key for VSI creation which does not already exist in the deployment region | `string` | unique | yes | quickstart, standard |
| [ports] | Inbound port for telnet & zosmf web browser for Wazi VSI SG  | `list(number)` | n/a | yes | quickstart, standard |
| [image_name] | valid image name for Wazi VSI | `string` | "ibm-zos-2-5-s390x-dev-test-wazi-7" | yes | quickstart, standard |
| [resource_tags] | Optional list of tags to be added to created resources | `string` | n/a | no | quickstart, standard |
| [sm_service_plan] | Type of service plan to use to provision Secrets Manager if not using an existing one | `string` | "standard" | no | standard |
| [root_ca_name] | Name of the Root CA to create for a private_cert secret engine. Only used when var.existing_sm_instance_guid is false | `string` | "root-ca" | no | standard |
| [intermediate_ca_name] | Name of the Intermediate CA to create for a private_cert secret engine. Only used when var.existing_sm_instance_guid is false | `string` | "intermediate-ca" | no | standard |
| [certificate_template_name] | Name of the Certificate Template to create for a private_cert secret engine. When var.existing_sm_instance_guid is true, then it has to be the existing template name that exists in the private cert engine | `string` | "my-template" | no | standard |
| [create_policy] | Set to true to create a new access group (using the value of var.access_group_name) with a VPN Client role | `bool` | true | no | standard |
| [vpn_client_access_group_users] | List of users in the Client to Site VPN Access Group | `list(string)` | [] | no      standard |
| [access_group_name] | Name of the IAM Access Group to create if var.create_policy is true | `string` | client-to-site-vpn-access-group | no | standard |
| [root_ca_max_ttl] | Maximum TTL value for the root CA | `string` | "8760h" | yes | standard |
| [root_ca_common_name] | Fully qualified domain name or host domain name for the certificate to be created | `string` | "cloud.ibm.com" | no | standard |
| [resource_group] | Name of the resource group to use for this example. If not set, a resource group is created | `string` | null | no | standard |
| [cert_common_name] | Fully qualified domain name or host domain name for the private certificate to be created | `string` | n/a | no | standard |
| [override_json_string] | Override default values with custom JSON. Any value other than an empty string will override all other configuration changes | `string` | "" | no | quickstart, standard |
| [override] | Override default values with custom JSON template | `bool` | true | no | standard |


### Outputs

| Name | Description | Value | 
|------|-------------|-------|
| [config] | Output configuration as encoded JSON | [module.landing_zone.config](https://github.com/terraform-ibm-modules/terraform-ibm-landing-zone/blob/main/patterns/vsi/module/config.tf) | 

<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->


<!-- BEGIN CONTRIBUTING HOOK -->

<!-- Leave this section as is so that your module has a link to local development environment set up steps for contributors to follow -->
## Contributing

You can report issues and request features for this module in GitHub issues in the module repo. See [Report an issue or request a feature](https://github.com/terraform-ibm-modules/.github/blob/main/.github/SUPPORT.md).

To set up your local development environment, see [Local development setup](https://terraform-ibm-modules.github.io/documentation/#/local-dev-setup) in the project documentation.
<!-- Source for this readme file: https://github.com/terraform-ibm-modules/common-dev-assets/tree/main/module-assets/ci/module-template-automation -->
<!-- END CONTRIBUTING HOOK -->
