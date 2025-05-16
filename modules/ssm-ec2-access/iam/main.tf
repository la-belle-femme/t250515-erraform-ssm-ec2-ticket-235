# Create IAM role for EC2
resource "aws_iam_role" "ec2" {
  name = var.config.role_name

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Action = "sts:AssumeRole",
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      }
    ]
  })

  tags = merge(
    var.config.tags,
    {
      Name = format(
        "%s-%s-%s",
        var.config.tags["environment"],
        var.config.tags["project"],
        "ec2-role"
      )
    }
  )
}

# Attach managed IAM policies (SSM, CW, S3, etc.)
resource "aws_iam_role_policy_attachment" "managed" {
  for_each = toset(var.config.policy_arns)

  role       = aws_iam_role.ec2.name
  policy_arn = each.value
}

# Create custom KMS policy to allow EC2 to use the KMS key
resource "aws_iam_policy" "kms_policy" {
  name        = "SSMInstanceKMSPolicy"
  description = "Allows EC2 to use KMS for SSM session encryption"

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Action = [
          "kms:Encrypt",
          "kms:Decrypt",
          "kms:ReEncrypt*",
          "kms:GenerateDataKey*",
          "kms:DescribeKey"
        ],
        Resource = var.config.kms_key_arn
      }
    ]
  })

  tags = merge(
    var.config.tags,
    {
      Name = format(
        "%s-%s-%s",
        var.config.tags["environment"],
        var.config.tags["project"],
        "ec2-kms-policy"
      )
    }
  )
}

# Attach the custom KMS policy to the role
resource "aws_iam_role_policy_attachment" "kms_policy_attachment" {
  role       = aws_iam_role.ec2.name
  policy_arn = aws_iam_policy.kms_policy.arn
}

# Create IAM instance profile
resource "aws_iam_instance_profile" "ec2_profile" {
  name = var.config.instance_profile_name
  role = aws_iam_role.ec2.name

  tags = merge(
    var.config.tags,
    {
      Name = format(
        "%s-%s-%s",
        var.config.tags["environment"],
        var.config.tags["project"],
        "ec2-instance-profile"
      )
    }
  )
}
