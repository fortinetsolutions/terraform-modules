# Configuration for FortiAnalyzer with single NIC/Interface (BYOL)

This example creates an Instance of FortiAnalyzer with BYOL.

## Instances included in this Example

1. 1 VPC Networks
    - Public/Internal
1. Subnets for each VPC Network
    - Public
1. Firewalls
    - Creates 'INGRESS' and 'EGRESS' rules allowing all protocols.
1. External/Static IP
1. 1 Instances
    - BYOL
        - Deploys License

## References

1. https://docs.fortinet.com/document/fortianalyzer-public-cloud/7.0.0/gcp-administration-guide


## How do you run these examples?

1. Install [Terraform](https://www.terraform.io/).
1. Open `variables.tf`,  and fill in any required variables that don't have a default.
1. Run `terraform get`.
1. Run `terraform init`.
1. Run `terraform plan`.
1. If the plan looks good, run `terraform apply`.
