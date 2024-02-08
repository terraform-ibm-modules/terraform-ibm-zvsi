# VSI on VPC landing zone (QuickStart pattern)

![Architecture diagram for the QuickStart variation of VSI on VPC landing zone](https://github.com/terraform-ibm-modules/terraform-ibm-zvsi/assets/144440077/f154e64c-4d25-4fa6-8572-a79b20de1745)

This pattern deploys the following infrastructure:

- An edge VPC with 1 VSI in one of the three subnets and a VPC load balancer in the edge VPC, exposing the VSI publicly.
- A jump server VSI in the management VPC, exposing a public floating IP address.

**Important:** This pattern helps you get started quickly, but is not highly available or validated for the IBM Cloud Framework for Financial Services.
