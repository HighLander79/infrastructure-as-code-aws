output "s3_bucket_name" {
  description = "Nombre del bucket S3"
  value       = aws_s3_bucket.main.bucket
}

output "s3_bucket_arn" {
  description = "ARN del bucket S3"
  value       = aws_s3_bucket.main.arn
}

output "vpc_id" {
  description = "ID de la VPC principal"
  value       = aws_vpc.main.id
}

output "public_subnet_ids" {
  description = "IDs de las subnets públicas"
  value       = [aws_subnet.public_1a.id, aws_subnet.public_1b.id]
}

output "private_subnet_ids" {
  description = "IDs de las subnets privadas"
  value       = [aws_subnet.private_1a.id, aws_subnet.private_1b.id]
}
