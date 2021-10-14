# HA Active-Active with FGSP (FortiGate Session Life Support Protocol)

This example creates a HA Active-Active configuration with FGSP.
###### NOTE: FGSP is not enabled by default and needs to be applied manually after the configuration is deployed.

![Image of HA Active/Active FGSP](/GCP/examples/ha-active-active-fgsp/HA-FGSP.png)

## Instances included in this Configuration

1. 3 VPC Networks
    - Public/External/Untrust
    - Private/Internal/Trust
    - Sync
1. Subnets for each VPC Network
    - Public
    - Private
    - Sync
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
1. FGSP Configurations (Refer to the fgsp-config file)

## Connection to FortiGate Management GUI
1. To connect to the FortiGate Management GUI, one have to RDP into the Bastion Host and install Firefox/Chrome to access the FortiGate GUI.
1. Once done, enter the Internal IP (nic0) of the FortiGate with port 8443 (or whatever defined in terraform.tfvars for 'admin_port')

## References
https://docs.fortinet.com/document/fortigate/6.2.0/ports-and-protocols/796662/fgsp-fortigate-session-life-support-protocol

## How do you run these examples?

1. Install [Terraform](https://www.terraform.io/).
1. Open `variables.tf`,  and fill in any required variables that don't have a default. (or) to use the existing values, update `credentials_file_path`, `service_account_email`, `project` in `terraform.tfvars` file
1. Run `terraform get`.
1. Run `terraform init`.
1. Run `terraform plan`.
1. If the plan looks good, run `terraform apply`.
