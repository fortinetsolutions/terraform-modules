provider "aws" {
  region     = var.aws_region
  access_key = var.access_key
  secret_key = var.secret_key
}

data "template_file" "fmgr_userdata" {
  template = file("./fmgr-userdata.tpl")

  vars = {
    fgt_byol_license   = file("${path.module}/${var.fmgr_byol_license}")
    fgt_id             = "fgt-${var.customer_prefix}-${var.environment}-${var.availability_zone}"
  }
}

resource "aws_network_interface" "public_eni" {
  subnet_id                   = var.subnet_id
  private_ips                 = [var.ip_address]
  security_groups             = [ var.security_group_public_id ]
  source_dest_check           = false

  tags = {
    Name = "${var.customer_prefix}-${var.environment}-${var.fortimanager_instance_name}-ENI"
  }
}

resource "aws_instance" "fortimanager" {

  ami                         = var.aws_fmgrbyol_ami
  instance_type               = var.fmgr_instance_type
  availability_zone           = var.availability_zone
  key_name                    = var.keypair
  user_data                  = data.template_file.fmgr_userdata.rendered
  network_interface {
    device_index = 0
    network_interface_id   = aws_network_interface.public_eni.id
  }
  tags = {
    Name            = "${var.customer_prefix}-${var.environment}-${var.fortimanager_instance_name}"
    Environment     = var.environment
  }
}

