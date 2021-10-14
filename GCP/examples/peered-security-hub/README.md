# Peered Security Hub

This example creates a Peered Security Hub with Fortigate HA A/P.

## Introduction

GCP limitations related to deployment of multi-NIC instances make the usual architecture for deploying firewalls very static and costly (a classic 3-tier application would require an 8-core FGT instances). Peered Security Hub architecture provides flexibility of securing up to 25 segments using standard VM04 instances.

## Design

Hub-and-spoke design puts firewalls in the hub VPC Network and connects all VPC Networks to be inspected for traffic using peering. Default route defined in the Hub is propagated to the spokes using exportCustomRoutes/importCustomRoutes properties set on peerings (hub exports, spoke imports), thus enforcing traffic flow between spoke VPCs and from spokes to the Internet to be routed via firewalls.

![Image of Peered Security Hub - HA Active/Passive](/GCP/examples/peered-security-hub/peered-security-hub.png)

## Instances included in this Example

1. VPC Networks
    - Public/External/Untrust
    - Private/Internal/Trust
    - Sync
    - Management
    - Spoke VPCs
1. Subnets for each VPC Network
1. Firewalls
    - Creates 'INGRESS' and 'EGRESS' rules allowgin all protocols.
1. Route
    - default route to Internet for Fortigates
    - default route for all other instances in hub VPC (gets exported/imported to spokes)
1. External/Static IP
1. 2 Instances
    - Active
        - Deploys License
        - Updates Password
        - Configures HA
        - Configures GCP SDN Connector
        - Spoke Network Address Objects preconfigured
    - Passive
        - Deploys License
        - Updates Password
        - Configures HA
        - Configures GCP SDN Connector
        - Spoke Network Address Objects preconfigured
1. VPC Peerings
    - Peerings from Private/Internal/Trust Hub to spokes and vice-versa

## How do you run these examples?

1. Install [Terraform](https://www.terraform.io/).
1. Open `variables.tf`,  and fill in required variables that don't have a default. (CREDENTIALS, GCP_PROJECT, SERVICE_ACCOUNT_EMAIL, IMAGE, LICENSE_FILE)
1. Run `terraform get`.
1. Run `terraform init`.
1. Run `terraform plan`.
1. If the plan looks good, run `terraform apply`.
