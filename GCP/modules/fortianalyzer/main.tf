# Create log disk
resource "google_compute_disk" "faz_logdisk" {
  name = "faz-log-disk-${var.random_string}"
  size = 100
  type = "pd-ssd"
  zone = var.zone
}

# Compute Engine Instance
resource "google_compute_instance" "faz_instance" {
  name           = "${var.name}-instance"
  machine_type   = var.machine
  zone           = var.zone
  can_ip_forward = "true"
  tags           = ["faz-instance"]

  boot_disk {
    initialize_params {
      image = var.image
    }
  }

  attached_disk {
    source = google_compute_disk.faz_logdisk.name
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
    # user-data = data.template_file.setup-faz-instance.rendered
    # license   = file(var.license_file) # Placeholder for the license file for BYOL image, Need to fetch the License File
  }

  # Service Account and Scope
  service_account {
    email  = var.service_account
    scopes = ["cloud-platform"]
  }

  // When Changing the machine_type, min_cpu_platform, service_account, or enable display on an instance requires stopping it
  allow_stopping_for_update = true
}
