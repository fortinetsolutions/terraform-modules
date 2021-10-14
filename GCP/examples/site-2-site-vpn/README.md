# Site-2-Site VPN

This example creates a Site-2-Site VPN 

## Instances included in this Example

1. 1 VPC Networks
    - Public/Internal/Untrust
1. Subnets for each VPC Network
    - Public
1. Firewalls
    - Creates 'INGRESS' and 'EGRESS' rules allowing all protocols.
1. 1 External VPN Gateway
1. 1 HA VPN Gateway
    - 2 VPN Tunnels
1. 1 Cloud Router
    -  BGP Peers
1. Other Cloud FGT Bootstrap Configuration (fgt-config)    

## How do you run these examples?

1. Install [Terraform](https://www.terraform.io/).
1. Open `variables.tf`,  and fill in any required variables that don't have a default.
1. Run `terraform get`.
1. Run `terraform init`.
1. Run `terraform plan`.
1. If the plan looks good, run `terraform apply`.
