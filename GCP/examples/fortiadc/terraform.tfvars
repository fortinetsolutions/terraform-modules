credentials_file_path   = "<CREDENTIALS>"
project                 = "<GCP_PROJECT>"
service_account         = "<SERVICE_ACCOUNT_EMAIL>"
name                    = "terraform-fadc"
region                  = "us-south1"
zone                    = "us-south1-a"
machine                 = "n2-standard-2"
# FortiADC Image name
# https://fortinetweb.s3.amazonaws.com/docs.fortinet.com/v2/attachments/a5deac3c-fd5e-11ea-96b9-00505692583a/fortiadc-gcp-deployment-guide.pdf
image                   = "<IMAGE>"
license_file            = null
# VPCs
vpcs                    = ["untrust-vpc", "trust-vpc"]
# subnet module
subnets                 = ["untrust-subnet", "trust-subnet"]
subnet_cidrs            = ["10.10.1.0/24", "10.10.2.0/24"]
