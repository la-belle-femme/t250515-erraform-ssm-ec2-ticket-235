output "kms_key_id" {
  description = "ID of the created KMS key"
  value       = aws_kms_key.ssm_kms_key.key_id
}

output "kms_key_arn" {
  description = "ARN of the created KMS key"
  value       = aws_kms_key.ssm_kms_key.arn
}

output "kms_key_alias" {
  description = "Alias name of the KMS key"
  value       = aws_kms_alias.ssm_kms_alias.name
}
