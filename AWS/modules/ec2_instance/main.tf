
resource "aws_eip" "EIP" {
  count                 = var.enable_public_ips ? 1 : 0
  vpc                   = true
  network_interface     = aws_instance.ec2.primary_network_interface_id
  depends_on            = [ aws_instance.ec2 ]
  tags = {
    Name            = "${var.customer_prefix}-${var.environment}-${var.instance_name}"
    Environment     = var.environment
  }
}

resource "aws_eip" "HA_EIP" {
  count                 = var.enable_mgmt_public_ips ? 1 : 0
  vpc                   = true
  network_interface     = aws_network_interface.ha_eni[count.index].id
  depends_on            = [ aws_network_interface.ha_eni ]
  tags = {
    Name            = "${var.customer_prefix}-${var.environment}-${var.instance_name}"
    Environment     = var.environment
  }
}

resource "aws_network_interface" "private_eni" {
  count                       = var.enable_private_interface ? 1 : 0
  depends_on                  = [aws_instance.ec2]
  subnet_id                   = var.private_subnet_id
  private_ips                 = [ var.private_ip_address ]
  security_groups             = [ var.security_group_private_id ]
  source_dest_check           = false
  attachment {
    instance                  = aws_instance.ec2.id
    device_index              = 1
  }
  tags = {
    Name = "${var.customer_prefix}-${var.environment}-${var.instance_name}-ENI_Private"
  }
}

resource "aws_network_interface" "sync_eni" {
  count                       = var.enable_sync_interface ? 1 : 0
  depends_on                  = [aws_instance.ec2]
  subnet_id                   = var.sync_subnet_id
  private_ips                 = [ var.sync_ip_address ]
  security_groups             = [ var.security_group_public_id ]
  source_dest_check           = false
  attachment {
    instance                  = aws_instance.ec2.id
    device_index              = 2
  }

  tags = {
    Name = "${var.customer_prefix}-${var.environment}-${var.instance_name}-ENI_Sync"
  }
}

resource "aws_network_interface" "ha_eni" {
  count                       = var.enable_hamgmt_interface ? 1 : 0
  depends_on                  = [aws_instance.ec2]
  subnet_id                   = var.ha_subnet_id
  private_ips                 = [ var.ha_ip_address ]
  security_groups             = [ var.security_group_private_id ]
  source_dest_check           = false
  attachment {
    instance                  = aws_instance.ec2.id
    device_index              = 3
  }
  tags = {
    Name = "${var.customer_prefix}-${var.environment}-${var.instance_name}-ENI_hamgmt"
  }
}

resource "aws_instance" "ec2" {
  ami                         = var.aws_ami
  instance_type               = var.instance_type
  availability_zone           = var.availability_zone
  subnet_id                   = var.public_subnet_id
  key_name                    = var.keypair
  user_data                   = var.userdata_rendered
  iam_instance_profile        = var.iam_instance_profile_id
  private_ip                  = var.public_ip_address
  security_groups             = [ var.security_group_public_id ]
  tags = {
    Name            = "${var.customer_prefix}-${var.environment}-${var.instance_name}"
    Environment     = var.environment
  }
}

