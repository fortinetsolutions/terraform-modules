resource "google_compute_route" "custom_route" {
  name             = "${var.name}-custom-route-${var.random_string}"
  dest_range       = var.dest_range
  network          = var.vpc_network
  next_hop_ip      = var.next_hop_ip
  next_hop_gateway = var.next_hop_gateway
  priority         = var.priority
  tags             = var.tags
  depends_on       = [var.route_depends_on]
}
