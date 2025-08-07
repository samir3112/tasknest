#!/bin/bash
yum update -y
yum install -y docker
systemctl start docker
systemctl enable docker
usermod -aG docker ec2-user

docker pull samir3112/tasknest-api
docker run -d -p 5000:5000 samir3112/tasknest-api
