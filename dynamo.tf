# DynamoDB Table for Terraform State Locking
resource "aws_dynamodb_table" "this" {
  count        = var.use_lockfile ? 0 : 1
  name         = "${var.org}-${var.app}-${var.env}-${var.region}-tf-state-lock"
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "LockID"

  attribute {
    name = "LockID"
    type = "S"
  }

  server_side_encryption {
    enabled     = true
    kms_key_arn = aws_kms_key.this.arn
  }

  tags = {
    Name        = "${var.org}-${var.app}-${var.env}-${var.region}-tf-state-lock"
    Environment = var.env
  }
}

output "dynamodb_table_name" {
  value = var.use_lockfile ? null : aws_dynamodb_table.this[0].name
}