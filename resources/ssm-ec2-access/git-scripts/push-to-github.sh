#!/bin/bash
# push-to-github.sh
# Script to push code to GitHub repository

# Colors for output
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

echo -e "${GREEN}============================================${NC}"
echo -e "${GREEN}    Pushing Terraform Code to GitHub        ${NC}"
echo -e "${GREEN}============================================${NC}"

# Get the git root directory
GIT_ROOT=$(git rev-parse --show-toplevel 2>/dev/null)
if [ -n "$GIT_ROOT" ]; then
    cd "$GIT_ROOT"
fi

# Set repository URL
GITHUB_REPO_URL="https://github.com/la-belle-femme/250515-terraform-ssm-ec2-ticket-235.git"
BRANCH_NAME="feature/235-warriors-team-terraform-ssm-ec2"

# Check if git is installed
if ! command -v git &> /dev/null; then
    echo -e "${YELLOW}Git is not installed. Please install git first.${NC}"
    exit 1
fi

# Step 1: Check if we're in a git repository
echo -e "\n${GREEN}Checking git repository status...${NC}"
if [ ! -d ".git" ]; then
    echo -e "${YELLOW}Not in a git repository. Initializing...${NC}"
    git init
    echo "Initialized git repository."
fi

# Step 2: Check current git status
echo -e "\n${GREEN}Checking current git status...${NC}"
git status

# Step 3: Check if GitHub remote exists
echo -e "\n${GREEN}Checking remote repositories...${NC}"
if ! git remote | grep -q "github"; then
    echo -e "${YELLOW}Adding GitHub remote...${NC}"
    git remote add github $GITHUB_REPO_URL
    echo "Added GitHub remote."
fi

# Display remotes
git remote -v

# Step 4: Add .gitignore if it doesn't exist
echo -e "\n${GREEN}Checking for .gitignore file...${NC}"
if [ ! -f ".gitignore" ]; then
    echo -e "${YELLOW}Creating .gitignore file...${NC}"
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
EOF2
    echo "Created .gitignore file."
fi

# Step 5: Add .gitignore file to git
echo -e "\n${GREEN}Adding .gitignore to git...${NC}"
git add .gitignore
git commit -m "Add .gitignore file to exclude Terraform state files and provider binaries"

# Step 6: Add remaining files
echo -e "\n${GREEN}Adding all other files...${NC}"
git add .
echo "Added files to git."

# Step 7: Commit changes
echo -e "\n${GREEN}Committing changes...${NC}"
read -p "Enter a commit message (default: 'Implement SSM EC2 access functionality for ticket #235'): " commit_msg
commit_msg=${commit_msg:-"Implement SSM EC2 access functionality for ticket #235"}
git commit -m "$commit_msg"
echo "Committed changes."

# Step 8: Switch to or create branch
echo -e "\n${GREEN}Checking branch...${NC}"
if ! git branch | grep -q "$BRANCH_NAME"; then
    echo -e "${YELLOW}Creating branch $BRANCH_NAME...${NC}"
    git checkout -b $BRANCH_NAME
    echo "Created and switched to branch $BRANCH_NAME."
else
    echo -e "${YELLOW}Switching to branch $BRANCH_NAME...${NC}"
    git checkout $BRANCH_NAME
    echo "Switched to branch $BRANCH_NAME."
fi

# Step 9: Push to GitHub
echo -e "\n${GREEN}Pushing to GitHub...${NC}"
git push -u github $BRANCH_NAME
echo "Pushed to GitHub."

echo -e "\n${GREEN}============================================${NC}"
echo -e "${GREEN}    Push Complete!                          ${NC}"
echo -e "${GREEN}============================================${NC}"
echo -e "Your code has been pushed to GitHub at:"
echo -e "${YELLOW}$GITHUB_REPO_URL${NC}"
echo -e "Branch: ${YELLOW}$BRANCH_NAME${NC}"
