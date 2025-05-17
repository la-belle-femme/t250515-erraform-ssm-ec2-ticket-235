resource "aws_instance" "this" {
  ami                    = var.config.ec2_instance_ami
  instance_type          = var.config.ec2_instance_type
  subnet_id              = var.config.create_on_public_subnet ? var.config.public_subnet : var.config.private_subnet
  key_name               = var.config.ec2_instance_key_name != "" ? var.config.ec2_instance_key_name : null
  vpc_security_group_ids = [var.config.sg_id]
  iam_instance_profile   = var.config.iam_instance_profile_name
  user_data              = var.config.user_data != "" ? var.config.user_data : null

  associate_public_ip_address = var.config.create_on_public_subnet
  disable_api_termination     = var.config.enable_termination_protection

  root_block_device {
    volume_size = tonumber(var.config.root_volume_size)
    volume_type = "gp3"
    encrypted   = true
  }

  tags = merge(
    var.config.tags,
    {
      Name = format(
        "%s-%s-%s",
        var.config.tags["environment"],
        var.config.tags["project"],
        var.config.instance_name
      )
    }
  )
}
