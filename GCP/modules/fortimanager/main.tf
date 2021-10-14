# Compute Engine Instance
resource "google_compute_instance" "fmg_instance" {
  name           = "${var.name}-fmg-instance"
  machine_type   = var.machine
  zone           = var.zone
  can_ip_forward = "true"
  tags           = ["fmg-instance"]

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

  # Metadata which will deploy the license and configure the HA
  metadata = {
    user-data = "${data.template_file.setup-fmg-instance.rendered}"
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
