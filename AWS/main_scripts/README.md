# Main Scripts for AWS Terraform


## Table of Contents
  - [Overview](./README.md#overview)
  - [base_vpc_dual_az](./README.md#base_vpc_dual_az)
  - [base_vpc_single_az](./README.md#base_vpc_single_az)
  - [deploy_fortimanager_existing_vpc](./README.md#deploy_fortimanager_existing_vpc)
  - [deploy_ha_pair_standalone_existing_vpc](./README.md#deploy_ha_pair_standalone_existing_vpc)


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
   
## deploy_fortimanager_existing_vpc

This template will deploy a Fortimanager into an existing VPC

### components:

    - Fortimanager Configuration File (contained in config/fmgr-userdata-(license-type).tpl
    - iam profile (iam permissions for Fortimanager ec2 instance)
    - security group 
    - ec2_instance Fortimanager

## deploy_ha_pair_standalone_existing_vpc

This template will deploy a Fortigate HA Pair into an existing VPC

### components:

    - Fortigate Configuration File (contained in config/fgt-userdata-(license-type).tpl
    - Linux EC2 Instance Configuration File (contained in config/web-userdata.tpl
    - iam profile (iam permissions for Fortimanager ec2 instance)
    - Public security group 
    - Public security group 
    - sync-subnet-1 (Sync Subnet for AZ 1)
    - sync-subnet-1 (Sync Subnet for AZ 2)
    - ha-subnet-1 (HA Subnet for AZ 1)
    - ha-subnet-1 (HA Subnet for AZ 2)
    - ec2_instance Fortigate Active
    - ec2_instance Fortigate Passive
    

    
    
