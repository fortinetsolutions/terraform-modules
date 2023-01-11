# Deploy Web Server for VPC Peering Lab

This example creates a Instance with Ubuntu and NGINX (Web Server) installed.

## Instances included in this Example

1. 1 VPC Networks
    - Public/Internal
1. Subnets for each VPC Network
    - Public
1. Firewalls
    - Creates 'INGRESS' and 'EGRESS' rules allowing all protocols.
1. External/Static IP
1. 1 Instances
    - Ubuntu with NGINX installed

## How do you run these examples?

1. Install [Terraform](https://www.terraform.io/).
1. Open `variables.tf`,  and fill in any required variables that don't have a default.
1. Run `terraform get`.
1. Run `terraform init`.
1. Run `terraform plan`.
1. If the plan looks good, run `terraform apply`.


## Examples

https://medium.com/anditb/virtual-machine-creation-in-google-cloud-platform-57b8c643a594