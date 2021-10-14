# Compute Router NAT
# https://www.terraform.io/docs/providers/google/r/compute_router_nat.html

resource "google_compute_router_nat" "cloud_nat" {
  name                               = "${var.name}-cloud-nat-${var.random_string}"
  router                             = var.cloud_router
  region                             = var.region
  nat_ip_allocate_option             = "AUTO_ONLY"
  source_subnetwork_ip_ranges_to_nat = "ALL_SUBNETWORKS_ALL_IP_RANGES"
}
