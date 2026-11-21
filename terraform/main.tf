variable "aws_access_key" {
  description = "Тимчасовий ключ доступу з HashiCorp Vault"
  type        = string
  sensitive   = true
}

variable "aws_secret_key" {
  description = "Тимчасовий секретний ключ з HashiCorp Vault"
  type        = string
  sensitive   = true
}

provider "aws" {
  region                      = "us-east-1"
  access_key                  = var.aws_access_key
  secret_key                  = var.aws_secret_key
  skip_credentials_validation = true
  skip_metadata_api_check     = true
  skip_requesting_account_id  = true

  endpoints {
    s3 = "http://localhost:4566"
  }
}

# БЕЗПЕЧНА КОНФІГУРАЦІЯ S3-БАКЕТА
resource "aws_s3_bucket" "coursework_bucket" {
  bucket = "my-secure-coursework-bucket-2026"
}

# 1. Блокування публічного доступу (виправляє CKV_AWS_20)
resource "aws_s3_bucket_public_access_block" "bucket_access" {
  bucket = aws_s3_bucket.coursework_bucket.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

# 2. Увімкнення версіонування (виправляє CKV_AWS_21)
resource "aws_s3_bucket_versioning" "bucket_versioning" {
  bucket = aws_s3_bucket.coursework_bucket.id
  versioning_configuration {
    status = "Enabled"
  }
}

# 3. Увімкнення шифрування на стороні сервера (виправляє CKV_AWS_19)
resource "aws_s3_bucket_server_side_encryption_configuration" "bucket_encryption" {
  bucket = aws_s3_bucket.coursework_bucket.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}
