variable "config" {
  description = "Configuration map for EC2 instance"
  type = object({
    aws_region                  = string
    instance_name               = string
    ec2_instance_ami            = string
    ec2_instance_type           = string
    create_on_public_subnet     = bool
    ec2_instance_key_name       = string
    enable_termination_protection = bool
    root_volume_size            = string
    sg_id                       = string
    iam_instance_profile_name   = string
    tags                        = map(string)
    vpc_id                      = string
    private_subnet              = string
    public_subnet               = string
  })
}
