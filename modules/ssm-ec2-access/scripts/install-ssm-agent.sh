#!/bin/bash
# Log everything we do
exec > >(tee /var/log/user-data.log|logger -t user-data -s 2>/dev/console) 2>&1
echo "Starting SSM agent installation..."

# Detect OS and install SSM agent accordingly
if [ -f /etc/amazon-linux-release ] || grep -q "Amazon Linux" /etc/os-release; then
  # Amazon Linux
  echo "Detected Amazon Linux"
  yum update -y
  yum install -y amazon-ssm-agent
  systemctl enable amazon-ssm-agent
  systemctl start amazon-ssm-agent
elif [ -f /etc/debian_version ] || grep -q "Debian\|Ubuntu" /etc/os-release; then
  # Debian/Ubuntu
  echo "Detected Debian/Ubuntu"
  apt-get update
  apt-get install -y amazon-ssm-agent
  systemctl enable amazon-ssm-agent
  systemctl start amazon-ssm-agent
elif [ -f /etc/redhat-release ] || grep -q "Red Hat\|CentOS" /etc/os-release; then
  # RHEL/CentOS
  echo "Detected RHEL/CentOS"
  yum update -y
  yum install -y https://s3.amazonaws.com/ec2-downloads-windows/SSMAgent/latest/linux_amd64/amazon-ssm-agent.rpm
  systemctl enable amazon-ssm-agent
  systemctl start amazon-ssm-agent
elif grep -q "SUSE" /etc/os-release; then
  # SUSE Linux
  echo "Detected SUSE Linux"
  zypper install -y amazon-ssm-agent
  systemctl enable amazon-ssm-agent
  systemctl start amazon-ssm-agent
else
  # Fallback - try to detect package manager
  echo "OS not directly recognized, trying to detect package manager"
  if command -v apt-get > /dev/null; then
    echo "apt-get found, assuming Debian-based system"
    apt-get update
    apt-get install -y amazon-ssm-agent
    systemctl enable amazon-ssm-agent
    systemctl start amazon-ssm-agent
  elif command -v yum > /dev/null; then
    echo "yum found, assuming RPM-based system"
    yum update -y
    yum install -y https://s3.amazonaws.com/ec2-downloads-windows/SSMAgent/latest/linux_amd64/amazon-ssm-agent.rpm
    systemctl enable amazon-ssm-agent
    systemctl start amazon-ssm-agent
  elif command -v zypper > /dev/null; then
    echo "zypper found, assuming SUSE-based system"
    zypper install -y amazon-ssm-agent
    systemctl enable amazon-ssm-agent
    systemctl start amazon-ssm-agent
  else
    echo "Could not determine package manager. Manual installation required."
    exit 1
  fi
fi

# Verify installation
echo "Verifying SSM agent installation..."
if systemctl status amazon-ssm-agent; then
  echo "SSM agent is active and running"
else
  echo "SSM agent installation failed or service not running"
  exit 1
fi
