provider "aws" {
  region                      = "us-east-1"
  access_key                  = "test"
  secret_key                  = "test"
  skip_credentials_validation = true
  skip_metadata_api_check     = true
  skip_requesting_account_id  = true

  endpoints {
    s3 = "http://localhost:4566"
  }
}

# ВРАЗЛИВІСТЬ IaC: Публічний S3-бакет без шифрування та версіонування
resource "aws_s3_bucket" "coursework_bucket" {
  bucket = "my-insecure-coursework-bucket-2026"
}

resource "aws_s3_bucket_acl" "bucket_acl" {
  bucket = aws_s3_bucket.coursework_bucket.id
  acl    = "public-read"
}
