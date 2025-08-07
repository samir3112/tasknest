output "ec2_public_ip" {
  value = aws_instance.tasknest_ec2.public_ip
}