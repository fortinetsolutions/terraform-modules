credentials_file_path           = "<credentials_file_path>"
service_account                 = "<service_account_email>"
project                         = "<project>"
name                            = "terraform-fgsp"
region                          = "us-central1"
zone                            = "us-central1-c"
machine                         = "n1-standard-4"
# FortiGate Image name
# 6.4.2 payg is projects/fortigcp-project-001/global/images/fortinet-fgtondemand-642-20200810-001-w-license
# 6.4.2 byol is projects/fortigcp-project-001/global/images/fortinet-fgt-642-20200810-001-w-license
# image                         = "projects/fortigcp-project-001/global/images/fortinet-fgtondemand-642-20200810-001-w-license"
image                           = "projects/se-projects-242100/global/images/fgt-vm-6-6-0-2287-payg"
bastionhost_image               = "windows-cloud/windows-2019"  
bastionhost_machine             = "n1-standard-2"
admin_port                      = 8443
# VPCs
vpcs                            = ["public-vpc","private-vpc","fgsp-vpc"]
# Subnet
subnets                         = ["public-subnet","private-subnet","fgsp-subnet"]
subnet_cidrs                    = ["10.130.254.0/24","10.130.10.0/24","10.130.150.0/24"]
# Instance Template Variables
private_vpc_cidr                = "10.130.10.0"
private_vpc_gateway             = "10.130.10.1"
mapped_ip                       = "192.168.195.1"
# Managed Instance Group Variables
target_size                     = 2
autohealing_check_interval_sec  = 30
autohealing_timeout_sec         = 5
autohealing_healthy_threshold   = 2
autohealing_unhealthy_threshold = 10 # 300 seconds
autohealing_tcp_health_check    = 8443
initial_delay_sec               = 500
# External Load Balancer
elb_check_interval_sec          = 3
elb_timeout_sec                 = 2
elb_unhealthy_threshold         = 3
elb_port                        = 8008
# Internal Load Balancer
int_check_interval_sec          = 3
int_timeout_sec                 = 2
int_port                        = 8008


#### Custom work for Laureate
gcp_lb1             =       "130.211.0.0/22"  
gcp_lb2             =       "35.191.0.0/16"
ilb_vip             =       "10.130.10.240"
