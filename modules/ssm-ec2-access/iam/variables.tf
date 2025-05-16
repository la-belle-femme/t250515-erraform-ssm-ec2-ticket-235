variable "config" {
  description = "Configuration map for IAM role and instance profile"
  type = object({
    role_name             = string
    instance_profile_name = string
    policy_arns           = list(string)
    kms_key_arn           = string
    tags                  = map(string)
  })
}

