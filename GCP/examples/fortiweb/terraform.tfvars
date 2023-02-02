credentials_file_path     = "<CREDENTIALS>"
project                   = "<GCP_PROJECT>"
service_account           = "<SERVICE_ACCOUNT_EMAIL>"
name                    = "terraform-fweb"
region                  = "us-central1"
zone                    = "us-central1-c"
machine                 = "n2-standard-4"
# FortiWeb Image name
# 6.3.1 byol is projects/fortigcp-project-001/global/images/fortiweb-gcp-631-byol-release
# 6.3.2 byol is projects/fortigcp-project-001/global/images/fortiweb-gcp-632-byol-release
# 7.0.0 byol is projects/fortigcp-project-001/global/images/fwb-700-byol-12162021-001-w-license
# 7.0.1 byol is projects/fortigcp-project-001/global/images/fwb-701-byol-04222022-001-w-license
# image                   = "<IMAGE>"
image                   = "projects/fortigcp-project-001/global/images/fwb-701-byol-04222022-001-w-license"
# license_file            = "/Users/schitupolu/Desktop/Work_Related/Licensed_Versions/FortiWeb/LIC-Files/FVVM02TM2200025.lic"
license_file            = null
# VPCs
vpcs                    = ["untrust-vpc", "trust-vpc", "mgmt-vpc"]
# subnet module
subnets                 = ["untrust-subnet", "trust-subnet", "mgmt-subnet"]
subnet_cidrs            = ["10.10.1.0/24", "10.10.2.0/24", "10.10.3.0/24"]
