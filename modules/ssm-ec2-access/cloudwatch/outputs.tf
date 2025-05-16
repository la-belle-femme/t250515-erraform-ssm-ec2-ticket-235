output "log_group_name" {
  value       = aws_cloudwatch_log_group.ssm.name
  description = "Name of the created CloudWatch log group"
}

output "log_group_arn" {
  value       = aws_cloudwatch_log_group.ssm.arn
  description = "ARN of the created CloudWatch log group"
}

