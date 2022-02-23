
aws_region                  = "us-east-1"
#
# Booleans to enable certain features
#
# Allow creation of Linux instances in east/west VPCs
#
enable_linux_instances                = true

# Variables likely to change
#
keypair                     = "mdw-poc-common"
acl                         = "private"
customer_prefix             = "mdw"
environment                 = "dev"
cidr_for_access             = "0.0.0.0/0"
availability_zone_1         = "us-east-1a"

#
# VPC CIDR's
#
vpc_cidr_east               = "192.168.0.0/25"
vpc_cidr_east-1             = "192.168.0.0/27"
vpc_cidr_east-2             = "192.168.0.32/27"
vpc_cidr_east-3             = "192.168.0.64/27"
vpc_name_east               = "east"

#
# Endpoints Variables
#
ec2_sg_name                 = "ec2"
linux_instance_name_east    = "East Linux Instance"
linux_instance_type         = "t3.small"
