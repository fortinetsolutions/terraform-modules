# Packet Mirroring

This example creates Packet Mirroring configuration.

![Image of Packet Mirroring](/GCP/examples/packet-mirroring/Packet_Mirroring.png)

## Instances included in this Configuration

1. 4 VPC Networks
    - Public/Internal
    - Private/External
    - Peering
    - Mirroring
1. Subnets for each VPC Network
    - Public
    - Private
    - Peering
    - Mirroring
1. Firewalls
    - Creates 'INGRESS' and 'EGRESS' rules allowing all protocols.
1. UnManaged Instance Group
1. Instance Template
    - Including Bootstrap of configuration for FortiGate.
        - Configures admin_port, static route, probe-response, firewall service custom, firewall policy.
        - Adds loopback, Virtual IPs.
1. 3 Instances
    - 1 FGT Instance
        - With bootstrapping admin-port and password
    - 2 Ubuntu VMs 
1. Internal Load Balancer
1. Health Check(s)

## Connection to FortiGate Management GUI
- To connect to the FortiGate Management GUI, use FortiGate IP with port 8443 (or whatever defined in terraform.tfvars for 'admin_port')

## How do you run these examples?

1. Install [Terraform](https://www.terraform.io/).
1. Open `variables.tf`,  and fill in any required variables that don't have a default. (or) to use the existing values, update `credentials_file_path`, `service_account_email`, `project` in `terraform.tfvars` file
1. Run `terraform get`.
1. Run `terraform init`.
1. Run `terraform plan`.
1. If the plan looks good, run `terraform apply`.
