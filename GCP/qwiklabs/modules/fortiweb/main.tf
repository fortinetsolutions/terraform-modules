# Create log disk for FortiWeb
resource "google_compute_disk" "fweb_logdisk" {
  name = "${var.name}-log-disk"
  size = 30
  type = "pd-standard"
  zone = var.zone
}

# Compute Engine Instance
resource "google_compute_instance" "fweb_instance" {
  name           = "${var.name}-fweb"
  machine_type   = var.machine
  zone           = var.zone
  can_ip_forward = "true"
  tags           = ["fweb-instance"]

  boot_disk {
    initialize_params {
      image = var.image
    }
  }

  attached_disk {
    source = google_compute_disk.fweb_logdisk.name
  }

  # Public/Untrust Network
  network_interface {
    network    = var.public_vpc_network
    subnetwork = var.public_subnet
    access_config {
      nat_ip = var.static_ip
    }
  }

  # Private/Trust Network
  network_interface {
    network    = var.private_vpc_network
    subnetwork = var.private_subnet
  }

  # Management Network
  network_interface {
    network    = var.mgmt_vpc_network
    subnetwork = var.mgmt_subnet
  }

  # Metadata which will deploy the license and configure the HA
  metadata = {
    user-data = data.template_file.setup-fweb-instance.rendered
    license   = var.license_file != null ? file(var.license_file) : null
  }

  // When Changing the machine_type, min_cpu_platform, service_account, or enable display on an instance requires stopping it
  allow_stopping_for_update = true
}
