locals {
  env = merge(
    yamldecode(file("${path.module}/../../../environments/region.yaml")),
    yamldecode(file("${path.module}/../../../environments/webforx.yaml"))
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
}

provider "aws" {
  region = local.env.ec2.aws_region
}

module "cloudwatch" {
  source = "../../../modules/ssm-ec2-access/cloudwatch"
  config = {
    ssm_log_group_name = local.env.cloudwatch.ssm_log_group_name
    retention_in_days  = local.env.cloudwatch.retention_in_days
    kms_key_arn        = local.env.cloudwatch.kms_key_arn
    tags               = local.env.tags
  }
}
