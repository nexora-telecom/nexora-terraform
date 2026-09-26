terraform {
  backend "s3" {
    bucket         = "nexora-telecom-tfstate-prod-708379561766"
    key            = "prod/terraform.tfstate"
    region         = "us-east-1"
    dynamodb_table = "nexora-telecom-tfstate-lock-prod"
    encrypt        = true
    profile        = "nexora-prod"
  }
}
