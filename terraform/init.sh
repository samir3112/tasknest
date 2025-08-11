#!/bin/bash
yum update -y
yum install -y docker
systemctl start docker
systemctl enable docker
usermod -aG docker ec2-user

docker pull samir3112/tasknest-api

docker run -d -p 80:5000 \
  -e DB_USER=admin \
  -e DB_PASS=password123 \
  -e DB_HOST=${db_endpoint} \
  -e DB_NAME=tasknestdb \
  samir3112/tasknest-api

# chmod 400 ~/tasknest/terraform/n-varginia.pem (Permission)
# ssh -i ~/.ssh/n-varginia.pem ec2-user@<EC2_PUBLIC_IP>
# docker ps
# docker ps -a (for all containers)
# curl http://<ip-address-ec2>/tasks
# curl -X POST http://<ip-address>/tasks -H "Content-Type: application/json" -d '{"title": "Learn Docker", "description": "Build and run containers"}'

# sudo yum install -y mariadb105  OR   1) sudo apt update  2) sudo apt install mysql-client -y
#  mysql -h <rds_endpoint> -u admin -p
# SHOW DATABASES
# USE contactdb;
# SHOW TABLES;
# SELECT * FROM contact;