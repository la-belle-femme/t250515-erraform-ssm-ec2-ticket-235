#!/bin/bash
# cleanup-sensitive-data.sh
# Script to clean up sensitive data and large files from git repository

# Colors for output
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m' # No Color

echo -e "${GREEN}============================================${NC}"
echo -e "${GREEN}    Cleaning Sensitive Data from Repository ${NC}"
echo -e "${GREEN}============================================${NC}"

# Get the git root directory
GIT_ROOT=$(git rev-parse --show-toplevel)
cd "$GIT_ROOT"

# Check if git is installed
if ! command -v git &> /dev/null; then
    echo -e "${RED}Git is not installed. Please install git first.${NC}"
    exit 1
fi

# Check if we're in a git repository
if [ ! -d ".git" ]; then
    echo -e "${RED}Not in a git repository. Please run this script from within a git repository.${NC}"
    exit 1
fi

# Step 1: Create/update .gitignore
echo -e "\n${GREEN}Creating/updating .gitignore file...${NC}"
cat > .gitignore << 'EOF2'
# Local .terraform directories
**/.terraform/*

# .tfstate files
*.tfstate
*.tfstate.*

# Crash log files
crash.log
crash.*.log

# Exclude all .tfvars files
*.tfvars
*.tfvars.json

# Ignore CLI configuration files
.terraformrc
terraform.rc

# Ignore override files
override.tf
override.tf.json
*_override.tf
*_override.tf.json

# Exclude terraform lock files
.terraform.lock.hcl

# Logs
*.log

# Local environment files containing secrets
*-secrets.yaml
*-credentials.yaml

# Large files
*.zip
*.tar.gz
*.iso
EOF2

echo "Updated .gitignore file."

# Step 2: Find large files (>10MB)
echo -e "\n${GREEN}Finding large files (>10MB)...${NC}"
LARGE_FILES=$(find . -type f -size +10M | grep -v ".git/")

if [ -n "$LARGE_FILES" ]; then
    echo -e "${YELLOW}Found the following large files:${NC}"
    echo "$LARGE_FILES"
    
    echo -e "\n${GREEN}Removing large files from git tracking (but keeping them locally)...${NC}"
    echo "$LARGE_FILES" | while read file; do
        if git ls-files --error-unmatch "$file" &> /dev/null; then
            git rm --cached "$file"
            echo "Removed $file from git tracking."
        else
            echo "$file is not tracked by git."
        fi
    done
else
    echo "No large files found."
fi

# Step 3: Find files that might contain sensitive data
echo -e "\n${GREEN}Finding files that might contain sensitive data...${NC}"
SENSITIVE_PATTERNS="password\|secret\|key\|token\|credential\|aws_access_key\|private_key"
POTENTIAL_SENSITIVE_FILES=$(grep -r "$SENSITIVE_PATTERNS" --include="*.tf" --include="*.yaml" --include="*.sh" --include="*.json" . | grep -v ".git/")

if [ -n "$POTENTIAL_SENSITIVE_FILES" ]; then
    echo -e "${YELLOW}Found potential sensitive data in the following files:${NC}"
    echo "$POTENTIAL_SENSITIVE_FILES"
    echo -e "${YELLOW}Please review these files manually to ensure no sensitive data is being committed.${NC}"
fi

# Step 4: Find .tfstate files
echo -e "\n${GREEN}Finding Terraform state files...${NC}"
TFSTATE_FILES=$(find . -name "*.tfstate*" | grep -v ".git/")

if [ -n "$TFSTATE_FILES" ]; then
    echo -e "${YELLOW}Found the following Terraform state files:${NC}"
    echo "$TFSTATE_FILES"
    
    echo -e "\n${GREEN}Removing Terraform state files from git tracking (but keeping them locally)...${NC}"
    echo "$TFSTATE_FILES" | while read file; do
        if git ls-files --error-unmatch "$file" &> /dev/null; then
            git rm --cached "$file"
            echo "Removed $file from git tracking."
        else
            echo "$file is not tracked by git."
        fi
    done
else
    echo "No Terraform state files found in git tracking."
fi

# Step 5: Remove .terraform directories from git tracking
echo -e "\n${GREEN}Finding .terraform directories...${NC}"
TERRAFORM_DIRS=$(find . -name ".terraform" -type d | grep -v ".git/")

if [ -n "$TERRAFORM_DIRS" ]; then
    echo -e "${YELLOW}Found the following .terraform directories:${NC}"
    echo "$TERRAFORM_DIRS"
    
    echo -e "\n${GREEN}Removing .terraform directories from git tracking (but keeping them locally)...${NC}"
    echo "$TERRAFORM_DIRS" | while read dir; do
        if git ls-files --error-unmatch "$dir" &> /dev/null; then
            git rm -r --cached "$dir"
            echo "Removed $dir from git tracking."
        else
            echo "$dir is not tracked by git."
        fi
    done
else
    echo "No .terraform directories found in git tracking."
fi

# Step 7: Add changes and commit
echo -e "\n${GREEN}Committing the cleanup changes...${NC}"
git add .gitignore
git commit -m "Add/update .gitignore to exclude sensitive and large files"

echo -e "\n${GREEN}============================================${NC}"
echo -e "${GREEN}    Cleanup Complete!                       ${NC}"
echo -e "${GREEN}============================================${NC}"
echo -e "${YELLOW}IMPORTANT:${NC} Before pushing to remote repositories,"
echo -e "make sure to run 'git status' and verify no sensitive files are being committed."
