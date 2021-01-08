# FortiOS FGCP AP HA (Dual AZ) with TGW Attachments in AWS


## Table of Contents
  - [Overview](./README.md#overview)
  - [base_vpc_dual_az](./README.md#base_vpc_dual_az)
  - [base_vpc_single_az](./README.md#base_vpc_single_az)


# Overview
This set of directories contains terraform templates that can be used to deploy common Fortinet Architectures. Each can be used standalone, or as part of a larger architecture to "modularize" the solution to common problems. This document will provide a high-level overview of each directory with required inputs.

## base_vpc_dual_az
This template is used to provide a base VPC for a dual Availability Zone (AZ) architecture. Many of the other directories assume an existing VPC will be used as a deployment target. If an existing VPC does not exist, this template will provide a target VPC 

### components:

    - Base VPC 
        - Default Route Table (not used)
    - Two Availability Zones (the following provided in each AZ)
        - Public Subnet
            - public route table
                - default route entry pointing to IGW
                - route table association for public subnet
        - Private Subnet
            - private route table
                - default route entry pointing to IGW
                - route table association for private subnet
    - Internet Gateway
    
### inputs: 
    - region: deployment region (us-east-1)
    - customer prefix: customer prefix used to TAG all components created by this template (my_customer_name)
    - environment: additional tag to specify environment used by a particular terraform apply (prod/dev/test/etc)
    - VPC Name (my_vpc_name)
    - Availabilty Zone for AZ 1 (us-east-1a)
    - Availabilty Zone for AZ 2 (us-east-1c)
    - VPC CIDR (192.168.0.0/16)
    - public1_subnet_cidr  (192.168.0.0/24)
    - public1_description  (public subnet for AZ 1)
    - public2_subnet_cidr  (192.168.1.0/24)
    - public2_description  (public subnet for AZ 2)
    - private1_subnet_cidr (192.168.2.0/24)
    - private1_description (private subnet for AZ 1)
    - private2_subnet_cidr (192.168.3.0/24)
    - private2_description (private subnet for AZ 2)
    
## base_vpc_single_az
This template is used to provide a base VPC for a single Availability Zone (AZ) architecture. Many of the other directories assume an existing VPC will be used as a deployment target. If an existing VPC does not exist, this template will provide a target VPC 

### components:

    - Base VPC 
        - Default Route Table (not used)
    - Single Availability Zone
        - Public Subnet
            - public route table
                - default route entry pointing to IGW
                - route table association for public subnet
        - Private Subnet
            - private route table
                - default route entry pointing to IGW
                - route table association for private subnet
    - Internet Gateway

### inputs: 
    - region: deployment region (us-east-1)
    - customer prefix: customer prefix used to TAG all components created by this template (my_customer_name)
    - environment: additional tag to specify environment used by a particular terraform apply (prod/dev/test/etc)
    - VPC Name (my_vpc_name)
    - Availabilty Zone for AZ 1 (us-east-1a)
    - VPC CIDR (192.168.0.0/16)
    - public1_subnet_cidr  (192.168.0.0/24)
    - public1_description (public subnet for AZ 1)
    - private1_subnet_cidr (192.168.1.0/24)
    - private1_description (private subnet for AZ 1)
