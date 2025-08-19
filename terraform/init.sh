#!/bin/bash
yum update -y
yum install -y docker
systemctl start docker
systemctl enable docker
usermod -aG docker ec2-user

# Install AWS CLI (needed for boto3 to pick IAM role credentials)
yum install -y awscli

# Pull latest image
docker pull samir3112/tasknest-api

# Run container with DB environment variables
docker run -d --restart always -p 80:5000 \
  -e DB_USER=admin \
  -e DB_PASS=password123 \
  -e DB_HOST=${db_endpoint} \
  -e DB_NAME=tasknestdb \
  -e S3_BUCKET=${bucket_name} \
  -e AWS_REGION=us-east-1 \
  samir3112/tasknest-api


# chmod 400 ~/tasknest/terraform/n-varginia.pem (Permission)
# ssh -i ~/.ssh/n-varginia.pem ec2-user@<EC2_PUBLIC_IP>
# docker ps
# If container not running then 1) sudo systemctl start docker and sudo systemctl enable docker then pull and run same as init.sh but rds & bucket put.
# docker ps -a (for all containers)
# curl http://<ip-address-ec2>/tasks
# curl -X POST http://<ip-address>/tasks -H "Content-Type: application/json" -d '{"title": "Learn Docker", "description": "Build and run containers"}'
# curl http://<ip-address-ec2>/tasks
# curl http://<ip-address-ec2>/export (s3)
# To check csv file 1) aws s3 cp://tasknest-bucket-12346/tasks_export.csv .  2) cat tasks_export.csv


# sudo yum install -y mariadb105  OR   1) sudo apt update  2) sudo apt install mysql-client -y
#  mysql -h <rds_endpoint> -u admin -p
# SHOW DATABASES
# USE contactdb;
# SHOW TABLES;
# SELECT * FROM contact;


# NEW METHOD
# terraform apply -auto-approve
# chmod +x update-github-secrets.sh ( For first time )
# ./update-github-secrets.sh
# git add .      git commit -m "My changes for Day 4/5"    git push origin main
