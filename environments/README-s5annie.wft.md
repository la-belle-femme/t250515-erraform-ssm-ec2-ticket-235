# Environment Configuration Files

This directory contains YAML configuration files for different environments:

- `webforx.yaml`: Contains the main configuration for the webforx environment
- `region.yaml`: Specifies AWS regions
- `connect.yaml`: Connection settings

## Usage

These files are loaded by the Terraform modules to configure resources based on environment.

## Important Note

Some sensitive values have been commented out for security. When using this configuration:

1. Uncomment the required values
2. Replace with your own values or references
3. Never commit actual secrets, ARNs, or keys to version control
