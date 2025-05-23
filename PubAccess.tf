resource "aws_s3_bucket_public_access_block" "vault_block" {
  bucket = aws_s3_bucket.secure_vault.id
  block_public_acls   = true
  block_public_policy = true
  ignore_public_acls  = true
  restrict_public_buckets = true
}