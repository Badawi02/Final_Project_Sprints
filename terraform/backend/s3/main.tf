resource "aws_s3_bucket" "bucket" {
    bucket = var.bucketName
    lifecycle {
        prevent_destroy = true
    }
}

resource "aws_s3_bucket_versioning" "enabled" {
  bucket = aws_s3_bucket.bucket.id
  versioning_configuration {
    status = "Enabled"
  }
}
