resource "aws_security_group" "this" {
  name        = var.config.sg_name
  description = "Security group managed by Terraform for EC2 with SSM"
  vpc_id      = var.config.vpc_id

  lifecycle {
    create_before_destroy = true
    ignore_changes = [
      description,
      tags["Name"]
    ]
  }


  dynamic "ingress" {
    for_each = var.config.allowed_ports
    content {
      description = "Allow access on port ${ingress.value} from VPN"
      from_port   = ingress.value
      to_port     = ingress.value
      protocol    = "tcp"
      cidr_blocks = [for cidr in values(var.config.allowed_ips) : cidr]
    }
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge(
    var.config.tags,
    {
      Name = format(
        "%s-%s-%s",
        var.config.tags["environment"],
        var.config.tags["project"],
        var.config.sg_name
      )
    }
  )
}
