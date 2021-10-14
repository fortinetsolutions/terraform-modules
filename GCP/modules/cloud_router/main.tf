# Cloud Router
# https://www.terraform.io/docs/providers/google/r/compute_router.html

resource "google_compute_router" "cloud_router" {
  name    = "${var.name}-cloud-router-${var.random_string}"
  network = var.vpc_network
  region  = var.region
  dynamic "bgp" {
    for_each = var.bgp != null ? [var.bgp] : []
    content {
      asn = var.bgp.asn
      # advertise_mode is intentionally set to CUSTOM to not allow "DEFAULT".
      # This forces the config to explicitly state what subnets and ip ranges
      # to advertise. To advertise the same range as DEFAULT, set
      # `advertise_groups = ["ALL_SUBNETS"]`.
      advertise_mode    = "CUSTOM"
      advertised_groups = lookup(var.bgp, "advertised_groups", null)

      dynamic "advertised_ip_ranges" {
        for_each = lookup(var.bgp, "advertised_ip_ranges", [])
        content {
          range       = advertised_ip_ranges.value.range
          description = lookup(advertised_ip_ranges.value, "description", null)
        }
      }
    }
  }
}
