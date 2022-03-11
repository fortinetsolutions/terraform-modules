
aws_region                  = "us-west-2"
availability_zone           = "a"

customer_prefix             = "mdw"
environment                 = "dev"

use_fortigate_byol          = false

cidr_block                  = "10.0.0.0/16"
subnet_count                = 2
subnet_bits                 = 8
fortigate_host_ip           = 10


keypair                     = "mdw-key-oregon"
fortigate_instance_type     = "t3.small"
fortigate_instance_name     = "fortigate-single"
fgt_byol_license            = "fgt1-license.lic"
fortios_version             = "7.0.5"
fgt_admin_password          = "Texas4me!"