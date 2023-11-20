#!/bin/bash

# Set Ansible repository path and credentials if needed
ANSIBLE_REPO="git@github.com:ramalaxmibandi/ansible-pipeline.git"
ANSIBLE_DIR="https://github.com/ramalaxmibandi/ansible-pipeline"

# Generated files from Terraform
TERRAFORM_FILES="https://github.com/ramalaxmibandi/terraform-pipeline"

# Navigate to the Ansible repository directory

# Pull the latest changes in the Ansible repository
git pull

# Copy generated Ansible files from Terraform output
cp "$TERRAFORM_FILES/ansible_inventory" .
cp "$TERRAFORM_FILES/ansible.cfg" .
cp "$TERRAFORM_FILES/private_key.pem" .

# Add, commit, and push changes
git add ansible_inventory ansible.cfg private_key.pem
git commit -m "Update Ansible files from Terraform"
git push origin main  
