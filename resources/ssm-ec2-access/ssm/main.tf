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

module "ssm" {
  source = "../../../modules/ssm-ec2-access/ssm"
  config = {
    enable_session_logging    = local.env.ssm.enable_session_logging
    cloudwatch_log_group_name = local.env.ssm.cloudwatch_log_group_name
    kms_key_id                = local.env.ssm.kms_key_id
    tags                      = local.env.tags
  }
}
