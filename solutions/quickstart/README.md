# VSI on VPC IBM Secure Landing Zone - QuickStart Variation

[![Graduated (Supported)](https://img.shields.io/badge/status-Graduated%20(Supported)-brightgreen?style=plastic)](https://terraform-ibm-modules.github.io/documentation/#/badge-status)
[![semantic-release](https://img.shields.io/badge/%20%20%F0%9F%93%A6%F0%9F%9A%80-semantic--release-e10079.svg)](https://github.com/semantic-release/semantic-release)
[![pre-commit](https://img.shields.io/badge/pre--commit-enabled-brightgreen?logo=pre-commit&logoColor=white)](https://github.com/pre-commit/pre-commit)
[![latest release](https://img.shields.io/github/v/release/terraform-ibm-modules/terraform-ibm-zvsi?logo=GitHub&sort=semver)](https://github.com/terraform-ibm-modules/terraform-ibm-zvsi/releases/latest)
[![Renovate enabled](https://img.shields.io/badge/renovate-enabled-brightgreen.svg)](https://renovatebot.com/)

![Architecture diagram for the QuickStart variation of VSI on VPC landing zone](https://raw.githubusercontent.com/terraform-ibm-zvsi/blob/init-quick-start/reference-architecture/Quickstart-variation.svg)

This pattern deploys the following infrastructure:

- Workload VPC with Wazi as a Service VSI with Floating IP.

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
### Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.3, < 1.6 |
| <a name="requirement_ibm"></a> [ibm](#requirement\_ibm) | >= 1.58.1 |

### Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_landing_zone"></a> [landing\_zone_](#module\_landing\_zone) | terraform-ibm-modules/landing-zone/ibm//patterns//vsi-quickstart | 4.13.0 |

<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->

