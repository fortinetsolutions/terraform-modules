resource "aws_lb" "nlb" {
  count = var.elb_type == "nlb" ? 1 : 0
  name = "${var.tag_name_prefix}-${var.tag_name_unique}-nlb"
  internal = var.elb_internal
  enable_cross_zone_load_balancing = true
  load_balancer_type = "network"
  subnets = [var.subnet1_id, var.subnet2_id]
}

resource "aws_lb_listener" "nlb_listener" {
  count = var.elb_type == "nlb" ? 1 : 0
  load_balancer_arn = aws_lb.nlb[count.index].arn
  port = var.elb_listner_port
  protocol = "TCP"
  default_action {
    type = "forward"
    target_group_arn = aws_lb_target_group.nlb_target_group[count.index].arn
  }
}

resource "aws_lb_target_group" "nlb_target_group" {
  count = var.elb_type == "nlb" ? 1 : 0
  name = "${var.tag_name_prefix}-${var.tag_name_unique}-tgrp"
  port = var.elb_listner_port
  protocol = "TCP"
  vpc_id = var.vpc_id
  health_check {
    protocol = "TCP"
    port = var.elb_listner_port
	interval = "10"
	healthy_threshold = "2"
	unhealthy_threshold = "2"
  }
}

resource "aws_lb_target_group_attachment" "nlb_target_group_attachment1" {
  count = var.elb_type == "nlb" ? 1 : 0
  target_group_arn = aws_lb_target_group.nlb_target_group[count.index].arn
  target_id = var.instance1_id
}

resource "aws_lb_target_group_attachment" "nlb_target_group_attachment2" {
  count = var.elb_type == "nlb" ? 1 : 0
  target_group_arn = aws_lb_target_group.nlb_target_group[count.index].arn
  target_id = var.instance2_id
}

resource "aws_lb" "alb" {
  count = var.elb_type == "alb" ? 1 : 0
  name = "${var.tag_name_prefix}-${var.tag_name_unique}"
  internal = var.elb_internal
  load_balancer_type = "application"
  security_groups    = [aws_security_group.alb_secgrp[count.index].id]
  subnets = [var.subnet1_id, var.subnet2_id]
}

resource "aws_lb_listener" "alb_listener" {
  count = var.elb_type == "alb" ? 1 : 0
  load_balancer_arn = aws_lb.alb[count.index].arn
  port = var.elb_listner_port
  protocol = "HTTP"
  default_action {
    type = "fixed-response"
    fixed_response {
      content_type = "text/plain"
      message_body = "Fixed response content from the alb, please use app specific urls for testing traffic flows"
      status_code  = "200"
    }
  }
}

resource "aws_security_group" "alb_secgrp" {
  count = var.elb_type == "alb" ? 1 : 0
  name = "${var.tag_name_prefix}-${var.tag_name_unique}-secgrp"
  description = "secgrp"
  vpc_id = var.vpc_id
  ingress {
    description = "Allow HTTP to ALB"
    from_port = 80
    to_port = 80
    protocol = "tcp"
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

resource "aws_lb_target_group" "alb_app1_target_group" {
  count = var.elb_type == "alb" ? 1 : 0
  name = "${var.tag_name_prefix}-${var.tag_name_unique}-tgrp1"
  port =  var.elb_app1_targetgroup_port
  protocol = "HTTP"
  vpc_id = var.vpc_id
  health_check {
    protocol = "HTTP"
    port = var.elb_app1_targetgroup_port
    path = "/${var.web_app1_name}/index.html"
    matcher = "200"
	interval = "5"
	timeout = "4"
	healthy_threshold = "2"
	unhealthy_threshold = "2"
  }
}

resource "aws_lb_listener_rule" "alb_app1_http_routing" {
  count = var.elb_type == "alb" ? 1 : 0
  listener_arn = aws_lb_listener.alb_listener[count.index].arn
  priority     = 1
  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.alb_app1_target_group[count.index].arn
  }
  condition {
    path_pattern {
    values = ["/app1/*"]
    }
  }
}

resource "aws_lb_target_group_attachment" "alb_app1_target_group_attachment1" {
  count = var.elb_type == "alb" ? 1 : 0
  target_group_arn = aws_lb_target_group.alb_app1_target_group[count.index].arn
  target_id = var.instance1_id
}

resource "aws_lb_target_group_attachment" "alb_app1_target_group_attachment2" {
  count = var.elb_type == "alb" ? 1 : 0
  target_group_arn = aws_lb_target_group.alb_app1_target_group[count.index].arn
  target_id = var.instance2_id
}

resource "aws_lb_target_group" "alb_app2_target_group" {
  count = var.elb_type == "alb" ? 1 : 0
  name = "${var.tag_name_prefix}-${var.tag_name_unique}-tgrp2"
  port =  var.elb_app2_targetgroup_port
  protocol = "HTTP"
  vpc_id = var.vpc_id
  health_check {
    protocol = "HTTP"
    port = var.elb_app2_targetgroup_port
    path = "/${var.web_app2_name}/index.html"
    matcher = "200"
	interval = "5"
	timeout = "4"
	healthy_threshold = "2"
	unhealthy_threshold = "2"
  }
}

resource "aws_lb_listener_rule" "alb_app2_http_routing" {
  count = var.elb_type == "alb" ? 1 : 0
  listener_arn = aws_lb_listener.alb_listener[count.index].arn
  priority = 2
  action {
    type = "forward"
    target_group_arn = aws_lb_target_group.alb_app2_target_group[count.index].arn
  }
  condition {
      path_pattern {
      values = ["/app2/*"]
      }
  }
}

resource "aws_lb_target_group_attachment" "alb_app2_target_group_attachment1" {
  count = var.elb_type == "alb" ? 1 : 0
  target_group_arn = aws_lb_target_group.alb_app2_target_group[count.index].arn
  target_id = var.instance1_id
}

resource "aws_lb_target_group_attachment" "alb_app2_target_group_attachment2" {
  count = var.elb_type == "alb" ? 1 : 0
  target_group_arn = aws_lb_target_group.alb_app2_target_group[count.index].arn
  target_id = var.instance2_id
}

resource "aws_lb" "gwlb" {
  count = var.elb_type == "gateway" ? 1 : 0
  name = "${var.tag_name_prefix}-${var.tag_name_unique}"
  enable_cross_zone_load_balancing = true
  load_balancer_type = "gateway"
  subnet_mapping {
    subnet_id            = var.subnet1_id
  }
  subnet_mapping {
    subnet_id            = var.subnet2_id
  }
}

resource "aws_lb_target_group" "gwlb_target_group" {
  count = var.elb_type == "gateway" ? 1 : 0
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

data "aws_network_interfaces" "gwlb_enis" {
  count = var.elb_type == "gateway" ? 1 : 0
  filter {
    name   = "description"
    values = ["ELB ${aws_lb.gwlb[count.index].arn_suffix}"]
  }
}


resource "aws_lb_target_group_attachment" "gwlb_target_group_attachment1" {
  count = var.elb_type == "gateway" ? 1 : 0
  target_group_arn = aws_lb_target_group.gwlb_target_group[count.index].arn
  target_id = var.instance1_id
}

resource "aws_lb_target_group_attachment" "gwlb_target_group_attachment2" {
  count = var.elb_type == "gateway" ? 1 : 0
  target_group_arn = aws_lb_target_group.gwlb_target_group[count.index].arn
  target_id = var.instance2_id
}