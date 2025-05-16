variable "config" {
  description = "Configuration map for security group"
  type = object({
    aws_region     = string
    vpc_id         = string
    sg_name        = string
    allowed_ports  = list(number)
    allowed_ips    = map(string)
    tags           = map(string)
  })
}
