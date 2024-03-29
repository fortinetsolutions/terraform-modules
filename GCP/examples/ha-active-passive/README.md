# Active-Passive HA FortiGate Cluster with Fabric (SDN) Connector Failover

## Overview
FGCP protocol natively does not work in L3 overlay networks. For cloud deployments it must be configured to use unicast communication, which slightly limits its functionality (e.g. only Active-Passive between 2 peers is possible) and enforces use of dedicated management interface. In this template port3 is used as heartbeat and FGCP sync interface and port4 is used as dedicated management interface.

As cloud networks do not allow any network mechanisms below IP layer (e.g. gratuitous arp) usually used in HA scenarios, this template configures FortiGates to interact with Google Cloud Compute API upon failover event. SDN connector will re-attach the public IP to port1 of newly active instance and rewrite the route on internal network to point to the new instance's port2 IP address.

HA multi-zone deployments provide 99.99% Compute Engine SLA vs. 99.5-99.9% for single instances. See [Google Compute Engine SLA](https://cloud.google.com/compute/sla) for details.

## Design
As unicast FGCP clustering of FortiGate instances requires dedicated heartbeat and management NICs, 2 additional VPC Networks need to be created (or indicated in configuration file). While versions 7.0.1 and newer allow to use the same NIC for both heartbeat and management, this design features 4 separate VPCs for external, internal, heartbeat and management NICs. Both instances are deployed in separate zones indicated in **zones** property/variables to enable GCP 99.99% SLA.

Additional resources deployed include:
- default route for the internal VPC Network pointing to the internal IP of primary FortiGate - this route will be re-written using Fabric Connector during failover to direct outbound traffic from internal network via the active instance. More granular routing can be deployed by template using the routes property
- 3 external IPs - one floating IP for incoming traffic from Internet and 2 management IPs
- Cloud Router/Cloud NAT service is used to allow outbound traffic from port1 of secondary FortiGate instance (e.g. for license activation)

![A-P HA Diagram](/GCP/examples/ha-active-passive/ha-a-p.png)

## Failover automation
Deployed FortiGates integrate with GCP fabric using an SDN Connector. Upon failover 2 actions are performed:
- named route is switched to the IP of the now active node
- named external IP is re-assigned to the now active node

These actions are triggered by FortiGate configuration:

```
config system sdn-connector
  set type gcp
  set ha-status enable
  config external-ip
    edit "EIP_NAME"
    next
  end
  config route
    edit "ROUTE_NAME"
    next
  end
end
```

Starting from version 7.0.2 FortiGates can also fail over protocol forwarding rules

```
config system sdn-connector
  config forwarding-rule
    edit "FORWARDING_RULE_NAME"
      set target "TARGET_INSTANCE_NAME"
    next
  end
end
```

Note that the configuration of system.sdn-connector.forwarding-rule will differ between instances as each will include its own target instance resource. target instance will not be created by SDN connector, but can be automatically created by the template.

## Instances included in this Example

1. 4 VPC Networks
    - Public/External/Untrust
    - Private/Internal/Trust
    - Sync
    - Management
1. Subnets for each VPC Network
    - Public
    - Private
    - Sync
    - Management
1. Firewalls
    - Creates 'INGRESS' and 'EGRESS' rules allowgin all protocols.
1. Route
    - Creates a route which has 'Next Hop IP' defined.
1. External/Static IP
1. 2 Instances
    - Active
        - Deploys License
        - Updates Password
        - Configures HA
        - Configures GCP SDN Connector
    - Passive
        - Deploys License
        - Updates Password
        - Configures HA
        - Configures GCP SDN Connector

## How do you run these examples?

1. Install [Terraform](https://www.terraform.io/).
1. Open `variables.tf`,  and fill in required variables that don't have a default. (CREDENTIALS, GCP_PROJECT, SERVICE_ACCOUNT_EMAIL, IMAGE, LICENSE_FILE)
1. Run `terraform get`.
1. Run `terraform init`.
1. Run `terraform plan`.
1. If the plan looks good, run `terraform apply`.
