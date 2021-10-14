# Compute Engine Instance - nginx
resource "google_compute_instance" "nginx_instance" {
  name           = "${var.name}-nginx-instance-${var.random_string}"
  machine_type   = var.machine
  zone           = var.zone
  can_ip_forward = "true"

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
    }
  }

  # Metadata which will deploy the license
  metadata = {
    user-data = data.template_file.setup-nginx-instance.rendered
  }

  // When Changing the machine_type, min_cpu_platform, service_account, or enable display on an instance requires stopping it
  allow_stopping_for_update = true
}
