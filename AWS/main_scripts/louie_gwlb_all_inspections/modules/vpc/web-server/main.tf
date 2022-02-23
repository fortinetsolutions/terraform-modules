provider "aws" {
  region = var.region
}

data "aws_ami" "webserver_ami" {
  most_recent      = true
  owners           = ["980933617837"]

  filter {
    name   = "name"
    values = ["ftnt-aws-jam-web"]
  }
}

resource "aws_security_group" "secgrp" {
  name = "${var.tag_name_prefix}-${var.tag_name_unique}-secgrp"
  description = "secgrp"
  vpc_id = var.vpc_id
  ingress {
    description = "Allow all traffic permitted by FGTs"
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    Name = "${var.tag_name_prefix}-${var.tag_name_unique}-secgrp"
  }
}

resource "aws_network_interface" "eni0" {
  subnet_id = var.subnet_id
  security_groups = [aws_security_group.secgrp.id]
  source_dest_check = false
  tags = {
    Name = "${var.tag_name_prefix}-${var.tag_name_unique}-eni0"
  }
}

resource "aws_eip" "eip" {
  vpc = true
  instance = aws_instance.web.id
  tags = {
    Name = "${var.tag_name_prefix}-${var.tag_name_unique}-eip"
  }
}

resource "aws_instance" "web" {
  ami = data.aws_ami.webserver_ami.id
  instance_type = var.instance_type
  availability_zone = var.availability_zone
  key_name = var.keypair
  user_data = data.template_file.web_userdata.rendered
  network_interface {
    device_index = 0
    network_interface_id = aws_network_interface.eni0.id
  }
  tags = {
	Name = "${var.tag_name_prefix}-${var.tag_name_unique}"
  }
}

data "template_file" "web_userdata" {
  template = file("${path.module}/web-userdata.tpl")

  vars = {
    web_app = var.web_app_name
    web_name = "${var.tag_name_prefix}-${var.tag_name_unique}"
    web_ip = sort(aws_network_interface.eni0.private_ips)[0]
	web_az = var.availability_zone
	web_vpc = var.vpc_id
  }
}