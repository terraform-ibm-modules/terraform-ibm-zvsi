<!-- BEGIN MODULE HOOK -->

<!-- Update the title to match the module name and add a description -->
# Terraform Modules Template Project
<!-- UPDATE BADGE: Update the link for the following badge-->
[![Incubating (Not yet consumable)](https://img.shields.io/badge/status-Incubating%20(Not%20yet%20consumable)-red)](https://terraform-ibm-modules.github.io/documentation/#/badge-status)
[![pre-commit](https://img.shields.io/badge/pre--commit-enabled-brightgreen?logo=pre-commit&logoColor=white)](https://github.com/pre-commit/pre-commit)
[![latest release](https://img.shields.io/github/v/release/terraform-ibm-modules/terraform-ibm-module-template?logo=GitHub&sort=semver)](https://github.com/terraform-ibm-modules/terraform-ibm-module-template/releases/latest)
[![Renovate enabled](https://img.shields.io/badge/renovate-enabled-brightgreen.svg)](https://renovatebot.com/)
[![semantic-release](https://img.shields.io/badge/%20%20%F0%9F%93%A6%F0%9F%9A%80-semantic--release-e10079.svg)](https://github.com/semantic-release/semantic-release)

<!-- Remove the content in this H2 heading after completing the steps -->

## Summary

This repository contains wazi deployable architecture solutions that help provision VPC landing zones and interconnect them. The below solutions are available in the IBM Cloud Catalog and can also be deployed with terraform.

Two solutions are offered:
1. [Quickstart Variation](https://github.com/terraform-ibm-modules/terraform-ibm-zvsi/tree/standard_quickstart/solutions/quickstart)
    This pattern deploys the following infrastructure:
    - Increases security with Key Management.
    - Collects and stores Internet Protocol (IP) traffic information with Activity Tracker and Flow Logs.
    - Simplifies risk management and demonstrates regulatory compliance with Financial Services
    - Uses an edge VPC for secure access through the public internet.
2. [Standard Variation](https://github.com/terraform-ibm-modules/terraform-ibm-zvsi/tree/standard_quickstart/solutions/standard)
    This pattern deploys the following infrastructure:
    - Seperate VPC for edge.
    - Seperate VPC for Workloads.
    - Virtual Server Instances for every subnet.
    - Increases security with Key Management.
    - Collects and stores Internet Protocol (IP) traffic information with Activity Tracker and Flow Logs.
    - Securely connects to multiple networks with a client-to-site/site-to-site virtual private network
    - Simplifies risk management and demonstrates regulatory compliance with Financial Services
    - Uses an edge VPC for secure access through the public internet.
<!-- Remove the content in this previous H2 heading -->
## Reference architectures
- [Quickstart Variation](https://github.com/terraform-ibm-modules/terraform-ibm-zvsi/tree/standard_quickstart/solutions/quickstart)
- [Standard Variation](https://github.com/terraform-ibm-modules/terraform-ibm-zvsi/tree/standard_quickstart/solutions/standard)

<!--
Add links to any reference architectures for this module.
(Usually in the `/reference-architectures` directory.)
See "Reference architecture" in Authoring Guidelines in the public documentation at
https://terraform-ibm-modules.github.io/documentation/#/implementation-guidelines?id=reference-architecture
-->

<!-- BEGIN OVERVIEW HOOK -->
## Overview
* [terraform-ibm-zvsi](#terraform-ibm-zvsi)
* [Submodules](./)
    * [quickstart](./solutions/quickstart/)
    * [standard](./solutions/standard/)
* [Contributing](#contributing)
<!-- END OVERVIEW HOOK -->

## Required IAM access policies

You need the following permissions to run this module.

- Account Management
    - **Resource Group** service
        - `Viewer` platform access
    - IAM Services
            - `Editor` platform access
        - **VPC Infrastructure Services** service
            - `Editor` platform access
        - **Transit Gateway** service
            - `Editor` platform access
        - **Direct Link** service
            - `Editor` platform access

<!-- END MODULE HOOK -->
<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
### Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.3, < 1.6 |
| <a name="requirement_ibm"></a> [ibm](#requirement\_ibm) | >= 1.56.1 |

<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->

<!-- BEGIN CONTRIBUTING HOOK -->

<!-- Leave this section as is so that your module has a link to local development environment set up steps for contributors to follow -->
## Contributing

You can report issues and request features for this module in GitHub issues in the module repo. See [Report an issue or request a feature](https://github.com/terraform-ibm-modules/.github/blob/main/.github/SUPPORT.md).

To set up your local development environment, see [Local development setup](https://terraform-ibm-modules.github.io/documentation/#/local-dev-setup) in the project documentation.
<!-- Source for this readme file: https://github.com/terraform-ibm-modules/common-dev-assets/tree/main/module-assets/ci/module-template-automation -->
<!-- END CONTRIBUTING HOOK -->
