# Configuration for FortiWeb Instance using fweb-template-data
data "template_file" "setup-fweb-instance" {
  template = file("${path.module}/fweb-template")
}
