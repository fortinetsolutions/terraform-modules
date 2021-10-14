
#
# Variable to be defined for user environment
#
aws_region                   = "us-west-2"
customer_prefix              = "mdw-fwb-demo"
environment                  = "dev"
vpc_name_security            = "web_security"
availability_zone_1          = "us-west-2a"
availability_zone_2          = "us-west-2c"

vpc_cidr_security            = "10.0.0.0/16"
public_subnet_cidr1          = "10.0.1.0/24"
public_subnet_cidr2          = "10.0.10.0/24"
private_subnet_cidr_1       = "10.0.2.0/24"
private_subnet_cidr_2       = "10.0.20.0/24"

public1_ip_address          = "10.0.1.11"
public1_description         = "public1-az1"

public2_ip_address          = "10.0.10.11"
public2_description         = "public2-az2"

private1_ip_address         = "10.0.2.11"
private2_ip_address         = "10.0.20.11"
private1_description        = "private1-az1"
private2_description        = "private2-az2"

fwb_byol_license_1           = "./licenses/fwb-license-1.lic"
fwb_byol_license_2           = "./licenses/fwb-license-1.lic"
keypair                      = "mdw-key-oregon"
fwb_s3_bucket                = "mdw-fwb-demo"

enable_public_ips_1          = true
enable_public_ips_2          = true
use_fortiweb_byol            = true


fortiweb_sg_name             = "fortiweb security group"
fortiweb_instance_type       = "c5.large"

fortiweb_1_instance_name     = "fortiweb_one"
fortiweb_2_instance_name     = "fortiweb_two"
fortiweb_os_version          = "6.3.7"
acl                          = "private"
fwb_admin_password           = "Texas4me!"





