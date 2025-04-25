# Terraform Infrastructure as Code Repository

## Overview


## Structure



## Project paths in s3
- At the root of the bucket, we should directory that represent the project name and create another directory in those to store the state file
```t
backend "s3" {
    bucket         = "dev-webfox-tf-state"
    key            = "web-fox/vpc/terraform.tfstate"
    region         = "us-east-1"
    encrypt        = true
    dynamodb_table = "dev-webfox-tf-state-lock"
  }

backend "s3" {
    bucket         = "dev-webfox-tf-state"
    key            = "connect/rds/terraform.tfstate"
    region         = "us-east-1"
    encrypt        = true
    dynamodb_table = "dev-webfox-tf-state-lock"
  }

backend "s3" {
    bucket         = "dev-web-fox-tf-state"
    key            = "edusuc/rds/terraform.tfstate"
    region         = "us-east-1"
    encrypt        = true
    dynamodb_table = "dev-webfox-tf-state-lock"
  }
```

## Example webfox s3 backend set up 
![alt text](/images/s3-backend.png)