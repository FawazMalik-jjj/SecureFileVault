# Configure AWS provider with MFA (replace with your credentials)
provider "aws" {
  region = "us-east-1"
}

# Create KMS key for encryption
resource "aws_kms_key" "vault_kms" {
  description             = "Secure File Vault Encryption Key"
  deletion_window_in_days = 30
  enable_key_rotation     = true
}

# S3 Bucket with encryption and versioning
resource "aws_s3_bucket" "secure_vault" {
  bucket = "secure-file-vault-${random_id.suffix.hex}"
  acl    = "private"

  versioning {
    enabled = true
  }

  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        kms_master_key_id = aws_kms_key.vault_kms.arn
        sse_algorithm     = "aws:kms"
      }
    }
  }
}

# IAM Policy to enforce MFA and restrict access
resource "aws_iam_policy" "vault_access_policy" {
  name = "SecureVaultAccessPolicy"
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Deny",
        Action = "s3:*",
        Resource = [
          aws_s3_bucket.secure_vault.arn,
          "${aws_s3_bucket.secure_vault.arn}/*"
        ],
        Condition = {
          BoolIfExists = {
            "aws:MultiFactorAuthPresent" = "false"
          }
        }
      }
    ]
  })
}

# Enable CloudTrail logging
resource "aws_cloudtrail" "vault_trail" {
  name           = "secure-vault-trail"
  s3_bucket_name = aws_s3_bucket.secure_vault.id
  include_global_service_events = true
}