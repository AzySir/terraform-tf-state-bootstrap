# KMS Key for S3 and DynamoDB encryption
resource "aws_kms_key" "this" {
  description             = "KMS key for Terraform state encryption"
  deletion_window_in_days = 10
  enable_key_rotation     = true
}

resource "aws_kms_alias" "this" {
  name          = "alias/${var.org}-${var.app}-${var.env}-${var.region}-tf-state-key"
  target_key_id = aws_kms_key.this.id
}

output "kms_key_arn" {
  value = aws_kms_key.this.arn
}