# VSI on VPC landing zone (QuickStart pattern)

![Architecture diagram for the QuickStart variation of VSI on VPC landing zone](https://raw.githubusercontent.com/terraform-ibm-modules/terraform-ibm-zvsi/init-quick-start/reference-architecture/QuickStart.svg)

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
