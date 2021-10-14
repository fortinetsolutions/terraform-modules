# HA Active-Active

This example creates a HA Active-Active configuration.

![Image of HA Active/Active](/GCP/examples/ha-active-active/HA-Active-Active.png)

## Instances included in this Configuration

1. 2 VPC Networks
    - Public/External/Untrust
    - Private/Internal/Trust
1. Subnets for each VPC Network
    - Public
    - Private
1. Firewalls
    - Creates 'INGRESS' and 'EGRESS' rules allowing all protocols.
1. Managed Instance Group
    - Autohealing
1. Instance Template
    - Including Bootstrap of configuration for FortiGate.
        - Configures admin_port, static route, probe-response, firewall service custom, firewall policy.
        - Adds loopback, Virtual IPs.
1. 2 Instances
1. Cloud Router
1. Cloud NAT
1. Internal Load Balancer
1. Health Check(s)
1. External Load Balancer

## Connection to FortiGate Management GUI
- To connect to the FortiGate Management GUI, one has to RDP into the Bastion Host and install Firefox.
- Once done, enter the Internal IP (nic0) of the FortiGate with port 8443 (or whatever defined in terraform.tfvars for 'admin_port')

## How do you run these examples?

1. Install [Terraform](https://www.terraform.io/).
1. Open `variables.tf`,  and fill in any required variables that don't have a default. (or) to use the existing values, update `credentials_file_path`, `service_account_email`, `project` in `terraform.tfvars` file
1. Run `terraform get`.
1. Run `terraform init`.
1. Run `terraform plan`.
1. If the plan looks good, run `terraform apply`.
