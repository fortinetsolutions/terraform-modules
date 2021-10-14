# Google Provider
provider "google" {
  version     = "3.5.0"
  credentials = var.project_credentials
  project = var.project
  region  = var.region
  zone    = var.zone
}
