
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

module "iam" {
  source = "../../../modules/ssm-ec2-access/iam"
  config = {
    role_name             = local.env.iam.role_name
    instance_profile_name = local.env.iam.instance_profile_name
    policy_arns           = local.env.iam.policy_arns
    kms_key_arn           = local.env.iam.kms_key_arn
    tags                  = local.env.tags
  }
}
