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
## Reference architectures
- [Quickstart Variation](https://github.com/terraform-ibm-modules/terraform-ibm-zvsi/tree/main/solutions/quickstart)
- [Standard Variation](https://github.com/terraform-ibm-modules/terraform-ibm-zvsi/tree/main/solutions/standard)
<!--
Add links to any reference architectures for this module.
(Usually in the `/reference-architectures` directory.)
See "Reference architecture" in Authoring Guidelines in the public documentation at
https://terraform-ibm-modules.github.io/documentation/#/implementation-guidelines?id=reference-architecture
-->

## Required IAM access policies

You need the following permissions to run this module.

- IAM Access Requirements
    - Quickstart Variation
        - **Platform Roles**
            - `Editor` Virtual Private Cloud
    - Standard Variation
        - **Platform Roles**
            - `Editor` IAM Identity Service
            - `Editor` Virtual Private Cloud
        - **Service Roles**
            - `Editor` Cloud Object Storage
            - `Editor` IBM Key Protect
<!-- END MODULE HOOK -->
<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
### Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\terraform) | >= 1.3, < 1.6 |
| <a name="requirement_ibm"></a> [ibm](#requirement\ibm) | >= 1.56.1 |

<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->

<!-- BEGIN CONTRIBUTING HOOK -->

<!-- Leave this section as is so that your module has a link to local development environment set up steps for contributors to follow -->
## Contributing

You can report issues and request features for this module in GitHub issues in the module repo. See [Report an issue or request a feature](https://github.com/terraform-ibm-modules/.github/blob/main/.github/SUPPORT.md).

To set up your local development environment, see [Local development setup](https://terraform-ibm-modules.github.io/documentation/#/local-dev-setup) in the project documentation.
<!-- Source for this readme file: https://github.com/terraform-ibm-modules/common-dev-assets/tree/main/module-assets/ci/module-template-automation -->
<!-- END CONTRIBUTING HOOK -->
