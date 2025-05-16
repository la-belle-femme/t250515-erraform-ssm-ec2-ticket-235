variable "config" {
  description = "Configuration map for KMS key"
  type = object({
    description = string
    alias_name  = string
    #account_id  = string
    aws_region  = string
    tags        = map(string)
  })
}
