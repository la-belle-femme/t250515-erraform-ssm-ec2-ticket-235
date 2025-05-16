# Get the current AWS account ID
data "aws_caller_identity" "current" {}

# Dynamically build the KMS key policy
data "aws_iam_policy_document" "ssm_kms_key_policy" {
  statement {
    sid    = "EnableRootUserPermissions"
    effect = "Allow"
    principals {
      type        = "AWS"
      identifiers = ["arn:aws:iam::${data.aws_caller_identity.current.account_id}:root"]
    }
    actions   = ["kms:*"]
    resources = ["*"]
  }

  statement {
    sid    = "AllowSSMUseOfKey"
    effect = "Allow"
    principals {
      type        = "Service"
      identifiers = ["ssm.amazonaws.com"]
    }
    actions = [
      "kms:Encrypt*",
      "kms:Decrypt*",
      "kms:ReEncrypt*",
      "kms:GenerateDataKey*",
      "kms:Describe*"
    ]
    resources = ["*"]
  }

  statement {
    sid    = "AllowCloudWatchUseOfKey"
    effect = "Allow"
    principals {
      type        = "Service"
      identifiers = ["logs.${var.config.aws_region}.amazonaws.com"]
    }
    actions = [
      "kms:Encrypt*",
      "kms:Decrypt*",
      "kms:ReEncrypt*",
      "kms:GenerateDataKey*",
      "kms:Describe*"
    ]
    resources = ["*"]
  }
}

# Create the KMS key for SSM session encryption
resource "aws_kms_key" "ssm_kms_key" {
  description             = var.config.description
  deletion_window_in_days = 30
  enable_key_rotation     = true
  policy                  = data.aws_iam_policy_document.ssm_kms_key_policy.json

  tags = merge(
    var.config.tags,
    {
      Name = format(
        "%s-%s-%s",
        var.config.tags["environment"],
        var.config.tags["project"],
        "ssm-session-kms-key"
      )
    }
  )
}

# Create a user-friendly alias
resource "aws_kms_alias" "ssm_kms_alias" {
  name          = var.config.alias_name
  target_key_id = aws_kms_key.ssm_kms_key.key_id
}

   

# Register the key in SSM Parameter Store and Configure default SSM session encryption
resource "aws_ssm_parameter" "session_encryption" {
  name        = "/EC2/SessionEncryption"
  overwrite   = true
  description = "Default KMS key for SSM session encryption"
  type        = "String"
  value       = aws_kms_key.ssm_kms_key.arn

  tags = merge(
    var.config.tags,
    {
      Name = format(
        "%s-%s-%s",
        var.config.tags["environment"],
        var.config.tags["project"],
        "ssm-session-kms-key"
      )
    }
  )
}
