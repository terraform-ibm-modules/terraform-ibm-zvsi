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

### Execution

1. Export API Key
    export TF_VAR_ibmcloud_api_key=XXX
2. Run Terraform init
3. Run Terraform apply -var-file=override.json
4. Input value for additional storage.
  ```var.data_volume_names
  Enter the details of Data Volume creation

  Enter a value: [{name="volume1",  capacity=10,  volume_name="vol1"},  {name="volume2",  capacity=11,  volume_name="vol2"}]
  ```

### List of all ports
List of all default ports added to Quickstar & Standard variations are documented here : https://www.ibm.com/docs/en/wazi-aas/1.0.0?topic=vpc-configurations-in-zos-stock-images#stock-image-configurations