# Network Connectivity Center 

An SD-WAN transit routing scenario with Google Network Connectivity Center (NCC) allows users to route data and exchange BGP routing information between two or more remote sites over the Google Cloud Platform Infrastructure.

This example deploys a NCC configuration with a Hub and a Spoke for a remote site in multiple regions ("US-Central1" and "US-West2").

![Design of NCC Architecture](/GCP/examples/network-connectivity-center/singleVM-NCC.png)

## Instances included in this Example

1. 1 NCC Hub
1. 2 Spokes
    - us-central1
    - us-west2
    - Deploys License for BOYL
    - Bootstraps the instances with "route-map", "router bgp", "vpn ipsec", "Interface - Tunnel", "firewall address", "firewall addrgrp", "router static", "firewall policy"
1. 2 Remote-Sites
    - us-central1
    - us-west2
    - Deploys License for BOYL
    - Bootstraps the instances with "route-map", "router bgp", "vpn ipsec", "Interface - Tunnel", "firewall address", "firewall addrgrp", "router static", "firewall policy"
1.  2 Cloud Routers
    - BGP Peers
    - Interfaces
1.  2 Cloud Functions (One Cloud Functions per Spoke)
1.  3 VPCs
    - Public/Internal
    - Private/External
    - Spoke VPCs
1. Subnets for each VPC Network
    - Public
    - Private
1. Firewalls
    - Creates 'INGRESS' and 'EGRESS' rules allowing all protocols.

## Deployment Specifications
Using this terraform template, one can deploy the whole configuration using a one "terraform apply" command.
One can use the same template to deploy the configuration in multiple regions (.i.e. Spokes or Remote Sites different regions), by just copying the Spoke and Remote Section, and providing the required variables/parameters.

###### NOTE: 
1.  **Service Account used in this deployment should require an "Owner" Role.**

## How do you run these examples?

1. Install [Terraform](https://www.terraform.io/).
1. Open `variables.tf`, and fill in any required variables that don't have a default.
1. Open `terraform.tfvars` file, and fill in required variables (which are empty) with appropriate values.
1. Run `terraform get`.
1. Run `terraform init`.
1. Run `terraform plan`.
1. If the plan looks good, run `terraform apply`.
