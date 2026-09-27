terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.0"
    }
  }
  required_version = ">= 1.5.0"
}


provider "aws" {
  region = var.aws_region
  assume_role {
    role_arn = "arn:aws:iam::729147110687:role/TerraformExecutionRole-Tooling"
  }
  default_tags {
    tags = {
      Environment = "tooling"
      Project     = "nexora-telecom"
      ManagedBy   = "terraform"
    }
  }
}