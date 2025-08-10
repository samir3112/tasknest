variable "aws_region" {
  default = "us-east-1"
}

variable "availability_zone" {
  default = ["us-east-1a","us-east-1b"]
}

variable "ami_id" {
  default = "ami-05ffe3c48a9991133"
}

variable "instance_type" {
  default = "t2.micro"
}

variable "key_name" {
  default = "n-varginia"
}