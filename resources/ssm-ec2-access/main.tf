locals {
  env = merge(
    yamldecode(file("${path.module}/../../environments/region.yaml")),
    yamldecode(file("${path.module}/../../environments/webforx.yaml"))
  )
}

terraform {
  required_version = ">= 1.10.5"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
  # Uncomment if you want to use S3 backend
  # backend "s3" {
  #   bucket         = "development-webforx-sandbox-tf-state"
  #   key            = "terraform.tfstate"
  #   region         = "us-east-1"
  #   encrypt        = true
  #   dynamodb_table = "development-webforx-sandbox-tf-state-lock"
  # }
}

provider "aws" {
  region = local.env.ec2.aws_region
}

data "aws_caller_identity" "current" {}

# -----------------------------------
# KMS Key for SSM Session Encryption
# -----------------------------------
module "kms" {
  source = "../../modules/ssm-ec2-access/kms"
  config = {
    description = local.env.kms.description
    alias_name  = local.env.kms.alias_name
    aws_region  = local.env.kms.aws_region
    tags        = local.env.tags
  }
}

# -----------------------------------
# IAM for EC2
# -----------------------------------
module "iam" {
  source = "../../modules/ssm-ec2-access/iam"
  config = {
    role_name             = local.env.iam.role_name
    instance_profile_name = local.env.iam.instance_profile_name
    policy_arns           = local.env.iam.policy_arns
    kms_key_arn           = module.kms.kms_key_arn # Use output from KMS module
    tags                  = local.env.tags
  }
}

# -----------------------------------
# CloudWatch Log Group for SSM
# -----------------------------------
module "cloudwatch" {
  source = "../../modules/ssm-ec2-access/cloudwatch"
  config = {
    ssm_log_group_name = local.env.cloudwatch.ssm_log_group_name
    retention_in_days  = local.env.cloudwatch.retention_in_days
    kms_key_arn        = module.kms.kms_key_arn # Use output from KMS module
    tags               = local.env.tags
  }
}

# -----------------------------------
# Security Group
# -----------------------------------
module "security_group" {
  source = "../../modules/ssm-ec2-access/security-group"
  config = merge(local.env.security_group, {
    tags = local.env.tags
  })
}

# -----------------------------------
# EC2 Instances (3 instances)
# -----------------------------------
module "ec2_instances" {
  for_each = {
    for i in range(3) : "instance-${i + 1}" => "ssm-managed-instance-${i + 1}"
  }
  source = "../../modules/ssm-ec2-access/ec2-instance"
  config = merge(local.env.ec2, {
    instance_name             = each.value
    sg_id                     = module.security_group.sg_id # Use output from security group module
    iam_instance_profile_name = local.env.ec2.iam_instance_profile_name
    tags                      = local.env.tags
  })
}

# -----------------------------------
# SSM Session Manager
# -----------------------------------
module "ssm" {
  source = "../../modules/ssm-ec2-access/ssm"
  config = {
    enable_session_logging    = local.env.ssm.enable_session_logging
    cloudwatch_log_group_name = local.env.ssm.cloudwatch_log_group_name
    kms_key_id                = module.kms.kms_key_id # Use output from KMS module
    tags                      = local.env.tags
  }
}
