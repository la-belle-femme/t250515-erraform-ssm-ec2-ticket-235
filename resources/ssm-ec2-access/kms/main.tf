
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
  region = local.env.kms.aws_region
}

data "aws_caller_identity" "current" {}

module "kms" {
  source = "../../../modules/ssm-ec2-access/kms"
  config = {
    description = local.env.kms.description
    alias_name  = local.env.kms.alias_name
    account_id  = data.aws_caller_identity.current.account_id
    tags        = local.env.tags
  }
}
