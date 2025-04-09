aws s3api put-bucket-versioning --bucket $BUCKET_NAME \
--versioning-configuration Status=Enabled,MFADelete=Enabled \
--mfa "your-mfa-serial-number your-mfa-code"