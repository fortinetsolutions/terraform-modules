# Compute Target Instance
# https://www.terraform.io/docs/providers/google/r/compute_target_instance.html
resource "google_compute_target_instance" "default" {
  name     = "${var.name}-target-${var.random_string}"
  instance = var.instance_id
}
