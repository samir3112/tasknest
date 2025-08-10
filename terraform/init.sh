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
# ssh -i n-varginia.pem ec2-user@<ec2-public-ip>
# docker ps
# docker ps -a (for all containers)
# curl http://<ip-address-ec2>/tasks
