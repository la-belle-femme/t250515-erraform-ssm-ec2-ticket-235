# SSM EC2 Access Implementation

This module implements secure, SSH-less EC2 access using AWS Systems Manager (SSM) Session Manager. It creates all necessary components to enable secure server access without exposing SSH ports.

## Features
- SSH-less EC2 access via SSM Session Manager
- Automatic installation and registration of SSM Agent
- KMS encryption for session data
- CloudWatch logging of all session activity
- IAM roles with appropriate permissions
- Security groups without SSH ports

## Usage

```bash
# From this directory:
terraform init
terraform plan
terraform apply
