output "ec2_public_ip" {
  value = aws_instance.tasknest_ec2.public_ip
}

output "rds_endpoint" {
  description = "MySQL RDS Endpoint"
  value       = aws_db_instance.tasknest_rds.address
}

output "s3_bucket" {
  description = "S3 bucket"
  value = aws_s3_bucket.tasknest_bucket.bucket
}