
#
# Booleans to enable certain features
#
# Allow creation of Linux instances in east/west VPCs
#
use_fortigate_byol                    = false
#
# Variables likely to change
#
keypair                     = "mdw-key-oregon"
aws_region                  = "us-west-2"
fortigate_customer_prefix   = "lsvpn-fortigate"
swan_customer_prefix        = "lsvpn-swan"
environment                 = "test"
fortigate_sg_name           = "fortigate-lsvpn"

fortigate_availability_zone = "us-west-2a"
swan_availability_zone      = "us-west-2a"

#
# VPC CIDR's
#
vpc_fortigate_name                    = "fortigate-vpn"
vpc_fortigate_cidr                    = "10.0.0.0/16"

#
# Subnet CIDR's
#
fortigate_public_subnet_cidr         = "10.0.1.0/24"
fortigate_private_subnet_cidr        = "10.0.2.0/24"

#
# Derived variables. IP address for Fortigate interfaces will be cidr for subnet + 10
#
fortigate_public_ip_address          = "10.0.1.20"
fortigate_public_description         = "fortigate-public"

fortigate_private_ip_address         = "10.0.2.20"
fortigate_private_description        = "fortigate-private"

#
# Fortigate Variables
#
cidr_for_access             = "0.0.0.0/0"
fortigate_instance_type     = "c5n.xlarge"
fortigate_instance_name     = "linksys-vpn-fortigate"

acl                         = "private"
fortios_version             = "7.0.5"
fgt_byol_license          = "./licenses/fgt1-license.lic"
fgt_admin_password          = "Texas4me!"
fortigate_hostname          = "fgt-lsvpn"


#
# SWAN VPC CIDR's
#
vpc_swan_name                    = "swan-vpn"
vpc_swan_cidr                    = "10.1.0.0/16"

#
# Subnet CIDR's
#
swan_public_subnet_cidr         = "10.1.1.0/24"
swan_private_subnet_cidr        = "10.1.2.0/24"

#
# Derived variables. IP address for swan interfaces will be cidr for subnet + 10
#
swan_public_ip_address          = "10.1.1.20"
swan_public_description         = "swan-public"

swan_private_ip_address         = "10.1.2.20"
swan_private_description        = "swan-private"
swan_sg_name                    = "lsvpn-swan"
swan_instance_type              = "t3.medium"
swan_instance_name              = "linksys-vpn-swan"

#
# VPN configuration
#
swan_vpn_psk                    = "VDtwPkLwJwq8/k+G12CkOJdB/GoGtbEDmR4jQXdg7t+gCMh/wGvIkgfNutYHVG5hiioPf2vY7+yi9YeavMRMuA=="