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
  region  = var.aws_region
  profile = "nexora-prod"
  default_tags {
    tags = {
      Environment = "prod"
      Project     = "nexora-telecom"
      ManagedBy   = "terraform"
    }
  }
}