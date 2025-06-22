# S3 Bucket for Terraform State
resource "aws_s3_bucket" "this" {
  bucket = "${var.org}-${var.app}-${var.env}-${var.region}-tf-state"

  tags = {
    Name        = "${var.org}-${var.app}-${var.env}-${var.region}-tf-state"
    Environment = var.env
  }
}

resource "aws_s3_bucket_versioning" "this" {
  bucket = aws_s3_bucket.this.id
  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "this" {
  bucket = aws_s3_bucket.this.id

  rule {
    apply_server_side_encryption_by_default {
      kms_master_key_id = aws_kms_key.this.arn
      sse_algorithm     = "aws:kms"
    }
  }
}

output "s3_bucket_name" {
  value = aws_s3_bucket.this.bucket
}