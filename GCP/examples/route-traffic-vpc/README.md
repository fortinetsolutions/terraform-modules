# Route Traffic through FortiGate to Web Server within VPC (same region)

This example creates a Fortigate Instance with BYOL, Ubuntu Instance (with nginx installed), an External IP, Compute Forwarding Rules, Compute Target Instance and bootstrap Fortigate with Static Route, Virtual IP, Firewall Policy which routes traffic through FortiGate to Ubuntu Instance (nginx) .

## Instances included in this Example

1. 2 VPC Networks
    - Public/Internal
    - Private/External
1. Subnets for each VPC Network
    - Public
    - Private
1. Firewalls
    - Creates 'INGRESS' and 'EGRESS' rules allowing all protocols.
1. External/Static IP
1. Compute Forwarding Rules
1. Compute Target Instance
1. 2 Instances
    - FortiGate BYOL
        - Deploys License
        - Updates Password
        - Static Route
        - Virtual IP
        - Firewall Policy
    - Ubuntu Instance
        - Installed nginx

## How do you run these examples?

1. Install [Terraform](https://www.terraform.io/).
1. Open `variables.tf`,  and fill in any required variables that don't have a default.
1. Run `terraform get`.
1. Run `terraform init`.
1. Run `terraform plan`.
1. If the plan looks good, run `terraform apply`.
