#!/bin/bash
# Scan S3 bucket for vulnerabilities and public access
aws s3api get-bucket-policy --bucket $BUCKET_NAME
aws s3api get-bucket-encryption --bucket $BUCKET_NAME
aws cloudtrail lookup-events --lookup-attributes AttributeKey=EventName,AttributeValue=DeleteBucket