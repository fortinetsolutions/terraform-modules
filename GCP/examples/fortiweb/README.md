# Configuration for FortiWeb

This example creates a deployment configruation for FortiWeb with BYOL/PAYG.

## Instances included in this Example

1. 2 VPC Networks
    - Public/Internal
    - Private/External
1. Subnets for each VPC Network
    - Public
    - Private
    - Mgmt
1. Firewalls
    - Creates 'INGRESS' and 'EGRESS' rules allowing all protocols.
1. External/Static IP
1. 1 Instances
    - BYOL
        - Deploys License

## How do you run these examples?

1. Install [Terraform](https://www.terraform.io/).
1. Open `variables.tf`,  and fill in any required variables that don't have a default.
1. Run `terraform get`.
1. Run `terraform init`.
1. Run `terraform plan`.
1. If the plan looks good, run `terraform apply`.
