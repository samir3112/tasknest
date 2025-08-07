# VPC
resource "aws_vpc" "tasknest_vpc" {
  cidr_block = "10.0.0.0/16"
  tags = {
    Name = "tasknest-vpc"
  }
}

# SUBNET
resource "aws_subnet" "tasknest_subnet" {
  vpc_id     = aws_vpc.tasknest_vpc.id
  cidr_block = "10.0.1.0/24"
  availability_zone = var.availability_zone
  map_public_ip_on_launch = true
  tags = {
    Name = "tasknest-subnet"
  }
}

resource "aws_internet_gateway" "tasknest_igw" {
  vpc_id = aws_vpc.tasknest_vpc.id
  tags = {
    Name = "tasknest-igw"
  }
}

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

resource "aws_route_table_association" "tasknest_rta" {
  subnet_id      = aws_subnet.tasknest_subnet.id
  route_table_id = aws_route_table.tasknest_rt.id
}

resource "aws_security_group" "tasknest_sg" {
  name        = "tasknest-sg"
  description = "Allow SSH and Flask port"
  vpc_id      = aws_vpc.tasknest_vpc.id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 5000
    to_port     = 5000
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

resource "aws_instance" "tasknest_ec2" {
  ami                         = var.ami_id  # Ubuntu 22.04 LTS
  instance_type               = var.instance_type
  subnet_id                   = aws_subnet.tasknest_subnet.id
  associate_public_ip_address = true
  vpc_security_group_ids      = [aws_security_group.tasknest_sg.id]
  key_name                    = var.key_name
  user_data                   = templatefile("${path.module}/init.sh", {
    dockerhub_username = var.dockerhub_username
  })

  tags = {
    Name = "tasknest-ec2"
  }
}