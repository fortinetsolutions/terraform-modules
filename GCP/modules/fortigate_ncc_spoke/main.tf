# Compute Engine Instance
resource "google_compute_instance" "fgt_spoke_instance" {
  name           = "${var.name}-fgt-spoke-instance"
  machine_type   = var.machine
  zone           = var.zone
  can_ip_forward = "true"
  tags           = ["fgt-spoke-instance"]

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

  # Private Network
  network_interface {
    network    = var.private_vpc_network
    subnetwork = var.private_subnet
  }

  # Metadata which will deploy the license and bootstraps the configuration
  metadata = {
    user-data = "${data.template_file.setup-ncc-instance.rendered}"
    license   = file(var.license_file) # Placeholder for the license file for BYOL image, Need to fetch the License File
  }

  # Service Account and Scope
  service_account {
    email  = var.service_account
    scopes = ["cloud-platform"]
  }

  // When Changing the machine_type, min_cpu_platform, service_account, or enable display on an instance requires stopping it
  allow_stopping_for_update = true
}
