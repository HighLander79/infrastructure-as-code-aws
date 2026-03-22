# S3 bucket para almacenamiento
resource "aws_s3_bucket" "main" {
  bucket = "${var.project}-${var.environment}-bucket"

  tags = {
    Name        = "${var.project}-${var.environment}-bucket"
    Environment = var.environment
    Project     = var.project
  }
}

# Bloquear acceso público (best practice)
resource "aws_s3_bucket_public_access_block" "main" {
  bucket = aws_s3_bucket.main.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}
