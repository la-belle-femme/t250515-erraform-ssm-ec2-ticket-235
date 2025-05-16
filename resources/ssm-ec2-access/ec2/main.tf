
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

module "ec2_instances" {
  for_each = {
    for i in range(3) : "instance-${i + 1}" => "ssm-managed-instance-${i + 1}"
  }

  source = "../../../modules/ssm-ec2-access/ec2-instance"
  config = merge(local.env.ec2, {
    instance_name             = each.value
    security_group_id         = local.env.ec2.sg_id
    iam_instance_profile_name = local.env.iam.instance_profile_name
    tags                      = local.env.tags
  })
}


# backend "s3" {
#   bucket         = "development-webforx-sandbox-tf-state"
#   key            = "connect/ec2/terraform.tfstate"
#   region         = "us-east-1"
#   encrypt        = true
#   dynamodb_table = "development-webforx-sandbox-tf-state-lock"
# }
