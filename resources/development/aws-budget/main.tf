locals {
  env = merge(
    yamldecode(file("${path.module}/../../../environments/region.yaml")).alias,
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


backend "s3" {
    bucket         = "development-webforx-sandbox-tf-state"
    key            = "webforx/aws-budget/terraform.tfstate"
    region         = "us-east-1"
    encrypt        = true
    dynamodb_table = "development-webforx-sandbox-tf-state-lock"
  }
}


module "aws-budget" {
  source              = "../../../modules/aws-budget"
  config = {
    budget_limit      = local.env.aws-budget.budget_limit 
    thresholds        = local.env.aws-budget.thresholds
    email_subscribers = local.env.aws-budget.email_subscribers
    aws_region        = local.env.aws_region_main
  }
   tags               = local.env.tags
}