# Create log disk
resource "google_compute_disk" "logdisk" {
  name = "${var.name}-log-disk-${var.random_string}"
  size = 30
  type = "pd-standard"
  zone = var.zone
}

# Compute Engine Instance
resource "google_compute_instance" "fts_instance" {
  name           = "${var.name}-fts-instance-${var.random_string}"
  machine_type   = var.machine
  zone           = var.zone
  can_ip_forward = "true"
  tags           = ["fts-instance"]

  boot_disk {
    initialize_params {
      image = var.image
    }
  }

  attached_disk {
    source = google_compute_disk.logdisk.name
  }

  # Mgmt Network
  network_interface {
    network    = var.mgmt_vpc_network
    subnetwork = var.mgmt_subnet
    access_config {
      nat_ip = var.static_ip
    }
  }

  # Traffic Port1 Network
  network_interface {
    network    = var.port1_vpc_network
    subnetwork = var.port1_subnet
  }

  # Traffic Port2 Network
  network_interface {
    network    = var.port2_vpc_network
    subnetwork = var.port2_subnet
  }

  # Metadata which will deploy the license and configure the HA
  metadata = {
    startup-script-url = "gs://skc-bucket/FortiTester/set_multiqueue.sh"
  }

  # Service Account and Scope
  service_account {
    email  = var.service_account
    scopes = ["cloud-platform"]
  }

  // When Changing the machine_type, min_cpu_platform, service_account, or enable display on an instance requires stopping it
  allow_stopping_for_update = true
}
