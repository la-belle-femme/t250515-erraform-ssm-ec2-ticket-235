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
  region = local.env.security_group.aws_region
}

module "security_group" {
  source = "../../../modules/ssm-ec2-access/security-group"
  config = merge(local.env.security_group, {
    tags = local.env.tags
  })
}
