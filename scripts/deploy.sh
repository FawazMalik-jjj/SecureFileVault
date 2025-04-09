#!/bin/bash
# Deploy infrastructure
cd infrastructure
terraform init
terraform apply -auto-approve

# Install backend dependencies
cd ../backend
pip install -r requirements.txt
export S3_BUCKET=$(terraform output -raw s3_bucket_name)
export KMS_KEY_ARN=$(terraform output -raw kms_key_arn)
nohup python app.py &