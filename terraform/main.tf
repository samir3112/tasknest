# VPC
resource "aws_vpc" "tasknest_vpc" {
  cidr_block = "10.0.0.0/16"
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name = "tasknest-vpc"
  }
}

# SUBNET
resource "aws_subnet" "tasknest_subnet_1" {
  vpc_id                  = aws_vpc.tasknest_vpc.id
  cidr_block              = "10.0.1.0/24"
  availability_zone       = var.availability_zone[0]
  map_public_ip_on_launch = true
  tags = {
    Name = "tasknest-subnet-1"
  }
}

resource "aws_subnet" "tasknest_subnet_2" {
  vpc_id                  = aws_vpc.tasknest_vpc.id
  cidr_block              = "10.0.2.0/24"
  map_public_ip_on_launch = true
  availability_zone       = var.availability_zone[1]
  tags = {
    Name = "tasknest-subnet-2"
  }
}

# Internet Gateway
resource "aws_internet_gateway" "tasknest_igw" {
  vpc_id = aws_vpc.tasknest_vpc.id
  tags = {
    Name = "tasknest-igw"
  }
}

# Route Table
resource "aws_route_table" "tasknest_rt" {
  vpc_id = aws_vpc.tasknest_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.tasknest_igw.id
  }
  tags = {
    Name = "tasknest-rt"
  }
}

# Route Table Association
resource "aws_route_table_association" "tasknest_rta1" {
  subnet_id      = aws_subnet.tasknest_subnet_1.id
  route_table_id = aws_route_table.tasknest_rt.id
}

resource "aws_route_table_association" "tasknest_rta2" {
  subnet_id      = aws_subnet.tasknest_subnet_2.id
  route_table_id = aws_route_table.tasknest_rt.id
}

# Security Group (allows MySQL & HTTP & SSH)
resource "aws_security_group" "tasknest_sg" {
  name        = "tasknest-sg"
  description = "Allow SSH and Flask port & Allow MySQL inbound traffic from EC2"
  vpc_id      = aws_vpc.tasknest_vpc.id

  ingress {
    from_port   = 5000
    to_port     = 5000
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 3306
    to_port     = 3306
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
  from_port   = 80
  to_port     = 80
  protocol    = "tcp"
  cidr_blocks = ["0.0.0.0/0"]
}


  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "tasknest-sg"
  }
}

# RDS MySQL
resource "aws_db_instance" "tasknest_rds" {
  engine                 = "mysql"
  engine_version         = "8.0"             # ✅ Supported with db.t3.micro
  instance_class         = "db.t3.micro"
  allocated_storage      = 20
  db_name                = "tasknestdb"
  username               = "admin"
  password               = "password123"
  publicly_accessible    = true
  skip_final_snapshot    = true
  db_subnet_group_name   = aws_db_subnet_group.db_subnet.id
  vpc_security_group_ids = [aws_security_group.tasknest_sg.id]

  tags = {
    Name = "contact-db"
  }
}


# DB Subnet Group
resource "aws_db_subnet_group" "db_subnet" {
  name       = "tasknest-db-subnet"
  subnet_ids = [aws_subnet.tasknest_subnet_1.id, aws_subnet.tasknest_subnet_2.id]
  description = "Managed by Terraform"
}

# S3 Bucket
resource "random_id" "suffix" {
  byte_length = 4  
}

resource "aws_s3_bucket" "tasknest_bucket" {
  bucket = "tasknest-bucket-${random_id.suffix.hex}"
  force_destroy = true

  tags = {
    Name = "tasknest-s3"
  }  
}

# IAM Role for EC2 -> S3
resource "aws_iam_role" "ec2_role" {
  name = "tasknest-ec2-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Action    = "sts:AssumeRole"
      Effect    = "Allow"
      Principal = {
        Service = "ec2.amazonaws.com"
      }
    }]
  })
}

resource "aws_iam_role_policy" "s3_policy" {
  name = "tasknest-s3-policy"
  role = aws_iam_role.ec2_role.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action   = ["s3:*"]
        Effect   = "Allow"
        Resource = [
          aws_s3_bucket.tasknest_bucket.arn,
          "${aws_s3_bucket.tasknest_bucket.arn}/*"
        ]
      }
    ]
  })
}

resource "aws_iam_instance_profile" "ec2_profile" {
  name = "taskknest-ec2-profile"
  role = aws_iam_role.ec2_role.name
}

# EC2 Instance
resource "aws_instance" "tasknest_ec2" {
  ami                         = var.ami_id  # Ubuntu 22.04 LTS
  instance_type               = var.instance_type
  subnet_id                   = aws_subnet.tasknest_subnet_1.id
  associate_public_ip_address = true
  vpc_security_group_ids      = [aws_security_group.tasknest_sg.id]
  key_name                    = var.key_name

  iam_instance_profile = aws_iam_instance_profile.ec2_profile.name

  user_data = templatefile("${path.module}/init.sh", {
    db_endpoint = aws_db_instance.tasknest_rds.address
    bucket_name = aws_s3_bucket.tasknest_bucket.bucket
  })
 

  tags = {
    Name = "tasknest-ec2"
  }
}