provider "aws" {
  region = var.region
}

resource "aws_iam_role" "iam-role" {
  name = "${var.tag_name_prefix}-iam-role"
  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "ec2.amazonaws.com"
      },
      "Effect": "Allow"
    }
  ]
}
EOF
}

resource "aws_iam_instance_profile" "iam_instance_profile" {
    name = "${var.tag_name_prefix}-iam-instance-profile"
    role = "${var.tag_name_prefix}-iam-role"
}

resource "aws_iam_role_policy" "iam-role-policy" {
  name = "${var.tag_name_prefix}-iam-role-policy"
  role = aws_iam_role.iam-role.id
  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": [
		"ec2:Describe*",
		"eks:Describe*"
      ],
      "Effect": "Allow",
      "Resource": "*"
    }
  ]
}
EOF
}

locals {
  ami_search_string = var.license_type == "byol" ? "FortiGate-VM64-AWS *(7.0.5)*" : "FortiGate-VM64-AWSONDEMAND *(7.0.5)*"
}

data "aws_ami" "fortigate_ami" {
  most_recent      = true
  owners           = ["679593333241"]

  filter {
    name   = "name"
    values = [local.ami_search_string]
  }
}

resource "aws_security_group" "secgrp" {
  name = "${var.tag_name_prefix}-secgrp"
  description = "secgrp"
  vpc_id = var.vpc_id
  ingress {
    description = "Allow remote access to FGT"
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = [var.cidr_for_access]
  }
  ingress {
    description = "Allow local VPC access to FGT"
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = [var.vpc_cidr]
  }
  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    Name = "${var.tag_name_prefix}-fgt-secgrp"
  }
}

resource "aws_security_group_rule" "ha_rule" {
  security_group_id = aws_security_group.secgrp.id
  type = "ingress"
  description = "Allow FGTs to access each other"
  from_port = 0
  to_port = 65535
  protocol = "-1"
  source_security_group_id = aws_security_group.secgrp.id
}

resource "aws_network_interface" "fgt1_eni0" {
  subnet_id = var.public_subnet1_id
  security_groups = [ aws_security_group.secgrp.id ]
  private_ips = [ element(split("/", var.fgt1_public_ip), 0) ]
  source_dest_check = false
  tags = {
    Name = "${var.tag_name_prefix}-fgt1-eni0"
  }
}

resource "aws_eip" "fgt1_eip" {
  vpc = true
  network_interface = aws_network_interface.fgt1_eni0.id
  associate_with_private_ip = element(split("/", var.fgt1_public_ip), 0)
  tags = {
    Name = "${var.tag_name_prefix}-fgt1_eip"
  }
}

resource "aws_instance" "fgt1" {
  ami = data.aws_ami.fortigate_ami.id
  instance_type = var.instance_type
  availability_zone = var.availability_zone1
  key_name = var.keypair
  iam_instance_profile = aws_iam_instance_profile.iam_instance_profile.id
  user_data = data.template_file.fgt1_userdata.rendered
  network_interface {
    device_index = 0
    network_interface_id = aws_network_interface.fgt1_eni0.id
  }
  tags = {
	Name = "${var.tag_name_prefix}-fgt1"
  }
}

data "template_file" "fgt1_userdata" {
  template = file("${path.module}/fgt1-userdata.tpl")
  
  vars = {
    gwlb_ip1 = element(var.gwlb_ip1, 0)
    gwlb_ip2 = element(var.gwlb_ip2, 0)
    fgt1_byol_license = file("${path.root}/${var.fgt1_byol_license}")
    fortigate_admin_password = var.fortigate_admin_password
  }
}

resource "aws_network_interface" "fgt2_eni0" {
  subnet_id = var.public_subnet2_id
  security_groups = [ aws_security_group.secgrp.id ]
  private_ips = [ element(split("/", var.fgt2_public_ip), 0) ]
  source_dest_check = false
  tags = {
    Name = "${var.tag_name_prefix}-fgt2-eni0"
  }
}

resource "aws_eip" "fgt2_eip" {
  vpc = true
  network_interface = aws_network_interface.fgt2_eni0.id
  associate_with_private_ip = element(split("/", var.fgt2_public_ip), 0)
  tags = {
    Name = "${var.tag_name_prefix}-fgt2_eip"
  }
}

resource "aws_instance" "fgt2" {
  ami = data.aws_ami.fortigate_ami.id
  instance_type = var.instance_type
  availability_zone = var.availability_zone2
  key_name = var.keypair
  iam_instance_profile = aws_iam_instance_profile.iam_instance_profile.id
  user_data = data.template_file.fgt2_userdata.rendered
  network_interface {
    device_index = 0
    network_interface_id = aws_network_interface.fgt2_eni0.id
  }
  tags = {
	Name = "${var.tag_name_prefix}-fgt2"
  }
}

data "template_file" "fgt2_userdata" {
  template = file("${path.module}/fgt2-userdata.tpl")
  
  vars = {
    gwlb_ip1 = element(var.gwlb_ip1, 0)
    gwlb_ip2 = element(var.gwlb_ip2, 0)
	fgt2_byol_license = file("${path.root}/${var.fgt2_byol_license}")
    fortigate_admin_password = var.fortigate_admin_password
  }
}