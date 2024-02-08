# VSI on VPC landing zone (QuickStart pattern)

![Architecture diagram for the QuickStart variation of VSI on VPC landing zone](https://github.com/terraform-ibm-modules/terraform-ibm-zvsi/assets/144440077/f154e64c-4d25-4fa6-8572-a79b20de1745)

This pattern deploys the following infrastructure:

- An edge VPC with Wazi as a Service VSI with Floating IP.

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
