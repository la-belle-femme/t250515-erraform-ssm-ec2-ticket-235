
locals {
  env = merge(
    yamldecode(file("${path.module}/../../environments/region.yaml")).alias,
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
}

module "auto-scaling-group" {
  source = "../../modules/auto-scaling-group"
  config = local.env.auto-scaling-group
  tags   = local.env.tags
}
