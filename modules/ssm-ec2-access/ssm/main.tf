# Create Session Manager preferences parameter
resource "aws_ssm_document" "ssm_preferences" {
  name          = "SSM-SessionManagerRunShell"
  document_type = "Session"

  content = jsonencode({
    schemaVersion = "1.0",
    description   = "SSM Session Manager shell preferences",
    sessionType   = "Standard_Stream",
    inputs = {
      cloudWatchLogGroupName       = var.config.cloudwatch_log_group_name
      cloudWatchEncryptionEnabled  = true
      cloudWatchStreamingEnabled   = true
      kmsKeyId                     = var.config.kms_key_id
    }
  })

  tags = merge(
    var.config.tags,
    {
      Name = format(
        "%s-%s-%s",
        var.config.tags["environment"],
        var.config.tags["project"],
        "ssm-session-doc"
      )
    }
  )
}
