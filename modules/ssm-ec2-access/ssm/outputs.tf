output "ssm_document_name" {
  description = "Name of the SSM preferences document"
  value       = aws_ssm_document.ssm_preferences.name
}

