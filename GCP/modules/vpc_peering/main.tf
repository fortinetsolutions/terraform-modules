# Creates VPC Peering
resource "google_compute_network_peering" "peerings" {
  count                = length(var.peerings)
  name                 = var.peerings[count.index].name
  export_custom_routes = var.peerings[count.index].export_custom_routes
  import_custom_routes = var.peerings[count.index].import_custom_routes
  network              = var.peerings[count.index].network
  peer_network         = var.peerings[count.index].peer_network
}
