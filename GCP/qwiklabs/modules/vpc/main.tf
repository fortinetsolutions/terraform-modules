# Creates VPC Network based on the variables defined 
resource "google_compute_network" "vpc" {
  count                   = length(var.vpcs)
  name                    = "${var.name}-${var.vpcs[count.index]}-${var.random_string}"
  auto_create_subnetworks = false
  routing_mode            = var.routing_mode 
}
