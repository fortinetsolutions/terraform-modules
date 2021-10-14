# Subnet(s)
resource "google_compute_subnetwork" "subnet" {
  count                    = length(var.subnets)
  name                     = "${var.name}-${var.subnets[count.index]}-${var.random_string}"
  region                   = var.region
  network                  = var.vpcs[count.index]
  ip_cidr_range            = var.subnet_cidrs[count.index]
  private_ip_google_access = var.private_ip_google_access != null ? var.private_ip_google_access[count.index] : false
}
