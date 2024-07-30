#!/bin/bash

# Get the directory of the currently running script
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Define paths
CREDENTIALS_PATH="$SCRIPT_DIR/../src/credentials"
TERRAFORM_DIR="$SCRIPT_DIR/../terraform"

# Ensure the credentials file is created/overwritten
echo "[default]" > "$CREDENTIALS_PATH"

# Fetch AWS credentials from Terraform output and append to the credentials file
echo "aws_access_key_id = $(terraform -chdir="$TERRAFORM_DIR" output -raw access_key_id)" >> "$CREDENTIALS_PATH"
echo "aws_secret_access_key = $(terraform -chdir="$TERRAFORM_DIR" output -raw secret_access_key)" >> "$CREDENTIALS_PATH"
