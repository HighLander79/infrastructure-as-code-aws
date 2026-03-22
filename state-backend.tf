resource "aws_s3_bucket" "terraform_state" {
  bucket = "${var.project}-${var.environment}-tfstate"

  tags = {
    Name        = "${var.project}-${var.environment}-tfstate"
    Environment = var.environment
    Project     = var.project
  }
}

resource "aws_s3_bucket_versioning" "terraform_state" {
  bucket = aws_s3_bucket.terraform_state.id

  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_public_access_block" "terraform_state" {
  bucket = aws_s3_bucket.terraform_state.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_dynamodb_table" "terraform_locks" {
  name         = "${var.project}-${var.environment}-tfstate-locks"
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "LockID"

  attribute {
    name = "LockID"
    type = "S"
  }

  tags = {
    Name        = "${var.project}-${var.environment}-tfstate-locks"
    Environment = var.environment
    Project     = var.project
  }
}
