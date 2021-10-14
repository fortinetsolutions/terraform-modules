
resource "google_compute_instance" "bastion_instance" {
  name         = "${var.name}-bastion-host-${var.random_string}"
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
    access_config {
      nat_ip = var.static_ip
    }
  }

  # Email will be the service account
  service_account {
    email  = var.service_account
    scopes = ["cloud-platform"]
  }
}
