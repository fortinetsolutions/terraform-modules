resource "aws_lb" "gwlb" {
  name = "${var.tag_name_prefix}-${var.tag_name_unique}"
  enable_cross_zone_load_balancing = true
  load_balancer_type = "gateway"
  subnet_mapping {
    subnet_id = var.subnet1_id
  }
  subnet_mapping {
    subnet_id = var.subnet2_id
  }
}

resource "aws_lb_target_group" "gwlb_target_group" {
  name = "${var.tag_name_prefix}-${var.tag_name_unique}-tgrp"
  protocol = "GENEVE"
  port =  "6081"
  vpc_id = var.vpc_id
  health_check {
    protocol = "TCP"
    port = var.elb_listner_port
	interval = "10"
	healthy_threshold = "2"
	unhealthy_threshold = "2"
  }
}

resource "aws_lb_listener" "gwlb_listner" {
  load_balancer_arn = aws_lb.gwlb.id
  default_action {
    target_group_arn = aws_lb_target_group.gwlb_target_group.id
    type = "forward"
  }
}

data "aws_network_interfaces" "gwlb_eni_az1" {
  filter {
    name   = "description"
    values = ["ELB ${aws_lb.gwlb.arn_suffix}"]
  }
  filter {
    name   = "subnet-id"
    values = [var.subnet1_id]
  }
}

data "aws_network_interfaces" "gwlb_eni_az2" {
  filter {
    name   = "description"
    values = ["ELB ${aws_lb.gwlb.arn_suffix}"]
  }
  filter {
    name   = "subnet-id"
    values = [var.subnet2_id]
  }
}

locals {
  gwlb_eni_id_az1 = flatten(data.aws_network_interfaces.gwlb_eni_az1.*.ids)
  gwlb_eni_id_az2 = flatten(data.aws_network_interfaces.gwlb_eni_az2.*.ids)
}

data "aws_network_interface" "gwlb_ip1" {
  id = element(local.gwlb_eni_id_az1, 0)
}

data "aws_network_interface" "gwlb_ip2" {
  id = element(local.gwlb_eni_id_az2, 0)
}

resource "aws_vpc_endpoint_service" "gwlb_endpoint_service" {
  acceptance_required        = false
  gateway_load_balancer_arns = [aws_lb.gwlb.arn]
}

resource "aws_lb_target_group_attachment" "gwlb_target_group_attachment1" {
  target_group_arn = aws_lb_target_group.gwlb_target_group.arn
  target_id = var.instance1_id
}

resource "aws_lb_target_group_attachment" "gwlb_target_group_attachment2" {
  target_group_arn = aws_lb_target_group.gwlb_target_group.arn
  target_id = var.instance2_id
}