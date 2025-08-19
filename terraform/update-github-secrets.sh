#!/bin/bash

cd terraform/

EC2_IP=$(terraform output -raw ec2_public_ip)
RDS_ENDPOINT=$(terraform output -raw rds_endpoint)
S3_BUCKET=$(terraform output -raw s3_bucket)

gh secret set EC2_HOST -b"$EC2_IP" -R samir3112/taskknest-api
gh secret set RDS_ENDPOINT -b"$RDS_ENDPOINT" -R samir3112/tasknest-api
gh secret set S3_BUCKET -b"$S3_BUCKET" -R samir3112/taskknest-api

echo "✅ Updated EC2_HOST: $EC2_IP"
echo "✅ Updated RDS_ENDPOINT: $RDS_ENDPOINT"
echo "✅ Updated S3_BUCKET: $S3_BUCKET"