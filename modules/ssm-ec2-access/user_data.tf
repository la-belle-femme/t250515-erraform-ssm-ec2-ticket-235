# File to manage user data scripts
locals {
  # Read the SSM installation script content
  ssm_install_script = file("${path.module}/scripts/install-ssm-agent.sh")
}

variable "enable_ssm_agent_installation" {
  description = "Whether to enable the SSM agent installation script"
  type        = bool
  default     = false
}

output "ssm_install_script" {
  description = "The SSM agent installation script"
  value       = local.ssm_install_script
}
