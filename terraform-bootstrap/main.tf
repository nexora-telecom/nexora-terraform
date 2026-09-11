data "aws_caller_identity" "tooling" {}
data "aws_caller_identity" "prod" {
  provider = aws.prod
}

resource "aws_s3_bucket" "tooling_state" {
  bucket = "${var.project_name}-tfstate-tooling-${data.aws_caller_identity.tooling.account_id}"
}
resource "aws_s3_bucket_versioning" "tooling_state_versioning" {
  bucket = aws_s3_bucket.tooling_state.id
  versioning_configuration {
    status = "Enabled"
  }
}
resource "aws_s3_bucket_server_side_encryption_configuration" "tooling_state_encryption" {
  bucket = aws_s3_bucket.tooling_state.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}
resource "aws_s3_bucket_public_access_block" "tooling_state_public_access_block" {
  bucket = aws_s3_bucket.tooling_state.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}
resource "aws_dynamodb_table" "tooling_state_dynamodb_table" {
  name         = "${var.project_name}-tfstate-lock-tooling"
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "LockID"
  attribute {
    name = "LockID"
    type = "S"
  }
}


resource "aws_s3_bucket" "prod_state" {
  provider = aws.prod
  bucket   = "${var.project_name}-tfstate-prod-${data.aws_caller_identity.prod.account_id}"
}
resource "aws_s3_bucket_versioning" "prod_state_versioning" {
  provider = aws.prod
  bucket   = aws_s3_bucket.prod_state.id
  versioning_configuration {
    status = "Enabled"
  }
}
resource "aws_s3_bucket_server_side_encryption_configuration" "prod_state_encryption" {
  provider = aws.prod
  bucket   = aws_s3_bucket.prod_state.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}
resource "aws_s3_bucket_public_access_block" "prod_state_public_access_block" {
  provider                = aws.prod
  bucket                  = aws_s3_bucket.prod_state.id
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}
resource "aws_dynamodb_table" "prod_state_dynamodb_table" {
  provider     = aws.prod
  name         = "${var.project_name}-tfstate-lock-prod"
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "LockID"
  attribute {
    name = "LockID"
    type = "S"
  }
}