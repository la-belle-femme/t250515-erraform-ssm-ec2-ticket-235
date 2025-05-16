variable "config" {
  description = "Configuration map for CloudWatch log group"
  type = object({
    ssm_log_group_name  = string
    retention_in_days   = number
    kms_key_arn         = string
    tags                = map(string)
  })
}
