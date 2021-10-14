
resource "google_compute_instance" "ubuntu_instance" {
  count        = var.instance_count
  name         = "${var.name}-ubuntu-instance-${var.random_string}-${count.index}"
  zone         = var.zone
  machine_type = var.machine
  #tags
  boot_disk {
    initialize_params {
      image = var.image
    }
  }

  # Public Network
  network_interface {
    network    = var.public_vpc_network
    subnetwork = var.public_subnet
    access_config {}
  }

  # Email will be the service account
  service_account {
    email  = var.service_account
    scopes = ["cloud-platform"]
  }
}
