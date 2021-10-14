# Compute Forwarding Rules
# https://www.terraform.io/docs/providers/google/r/compute_forwarding_rule.html
resource "google_compute_forwarding_rule" "tcp" {
  name       = "${var.name}-forwarding-rule-tcp-${var.random_string}"
  target     = var.target_instance_id
  ip_address = var.static_ip
}

resource "google_compute_forwarding_rule" "udp" {
  name        = "${var.name}-forwarding-rule-udp-${var.random_string}"
  target      = var.target_instance_id
  ip_address  = var.static_ip
  ip_protocol = "UDP"
}
