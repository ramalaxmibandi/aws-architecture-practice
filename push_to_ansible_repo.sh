#!/bin/bash

# Copy generated Ansible files from Terraform output
cp "$TERRAFORM_FILES/ansible_inventory" .
cp "$TERRAFORM_FILES/ansible.cfg" .
cp "$TERRAFORM_FILES/private_key.pem" .

# Add, commit, and push changes
git add ansible_inventory ansible.cfg private_key.pem
git commit -m "Update Ansible files from Terraform"
git remote add origin https://github.com/ramalaxmibandi/ansible-pipeline.git
git push origin main  
