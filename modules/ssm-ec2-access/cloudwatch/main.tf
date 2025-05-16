resource "aws_cloudwatch_log_group" "ssm" {
  name              = var.config.ssm_log_group_name
  retention_in_days = var.config.retention_in_days
  kms_key_id        = var.config.kms_key_arn

  tags = merge(
    var.config.tags,
    {
      Name = format(
        "%s-%s-%s",
        var.config.tags["environment"],
        var.config.tags["project"],
        var.config.ssm_log_group_name
      )
    }
  )
}

