
aws_region                  = "us-east-1"
customer_prefix             = "draftking"
environment                 = "test"
vpc_cidr                    = "10.0.0.0/16"

availability_zone1          = "us-east-1a"
availability_zone2          = "us-east-1c"

vpc_name                    = "draftking"
public1_subnet_cidr         = "10.0.1.0/24"
public1_description         = "public-subnet_1"
private1_subnet_cidr        = "10.0.2.0/24"
private1_description        = "private-subnet_1"
private1_tgw_subnet_cidr    = "10.0.3.0/24"
private1_tgw_description    = "private-tgw-subnet_1"

public2_subnet_cidr          = "10.0.10.0/24"
public2_description          = "public-subnet_2"
private2_subnet_cidr         = "10.0.20.0/24"
private2_description         = "private-subnet_2"
private2_tgw_subnet_cidr     = "10.0.30.0/24"
private2_tgw_description     = "private-tgw-subnet_2"



