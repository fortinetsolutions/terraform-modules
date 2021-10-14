# Configuration for FortiTester (BYOL)

This example creates an Instance of FortiTester with BYOL.

## Instances included in this Example

1. 3 VPC Networks
1. Subnets for each VPC Network
    - Management
    - Traffic Port1
    - Traffic Port2
1. Firewalls
    - Creates 'INGRESS' and 'EGRESS' rules allowing all protocols.
1. External/Static IP
1. 1 Instances
    - BYOL

## Login and Upload License
1. Login into the FortiTester using the IP Address. eg. https://<IP_ADDRESS>
1. Password is empty/blank initially, which needs to updated.
1. Upload the license from the System Settings Page.


## How do you run these examples?

1. Install [Terraform](https://www.terraform.io/).
1. Open `variables.tf`,  and fill in any required variables that don't have a default.
1. Run `terraform get`.
1. Run `terraform init`.
1. Run `terraform plan`.
1. If the plan looks good, run `terraform apply`.
