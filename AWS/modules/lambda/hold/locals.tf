
locals {
  package_hash = "${var.package_hash != "" ? var.package_hash : base64sha256(file(var.package_path))}"
}
