resource "random_string" "random" {
  length           = 5
  special          = false
}

resource "aws_security_group" "sg" {
  name = "${var.customer_prefix}-${var.environment}-${random_string.random.result}-${var.name}"
  description = "Allow required ports to the ec2 instance"
  vpc_id = var.vpc_id
  ingress {
    from_port   = var.ingress_from_port
    to_port     = var.ingress_to_port
    protocol    = var.ingress_protocol
    cidr_blocks = [ var.ingress_cidr_for_access]
  }
  egress {
    from_port   = var.egress_from_port
    to_port     = var.egress_to_port
    protocol    = var.egress_protocol
    cidr_blocks = [ var.egress_cidr_for_access]
  }
  tags = {
	Name = "${var.customer_prefix}-${var.environment}-${var.name}-SG"
    Environment = var.environment
  }
}
