terraform {
  backend "s3" {
    bucket         = "nexora-telecom-tfstate-tooling-729147110687"
    key            = "tooling/terraform.tfstate"
    region         = "us-east-1"
    dynamodb_table = "nexora-telecom-tfstate-lock-tooling"
    encrypt        = true
    profile        = "nexora-tooling"
  }
}
