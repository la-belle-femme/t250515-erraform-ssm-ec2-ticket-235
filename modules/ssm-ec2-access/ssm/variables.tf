variable "config" {
  description = "Configuration for SSM Session Manager"
  type = object({
    enable_session_logging = bool
    cloudwatch_log_group_name = string
    kms_key_id             = string
    tags                   = map(string)
  })
}
