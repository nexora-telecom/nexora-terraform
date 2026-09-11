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
  region  = "us-east-1"
  profile = "nexora-tooling"
  default_tags {
    tags = {
      Environment = "tooling"
      Project     = "nexora-telecom"
      ManagedBy   = "terraform"
    }
  }
}

provider "aws" {
  alias   = "prod"
  region  = "us-east-1"
  profile = "nexora-prod"
  default_tags {
    tags = {
      Environment = "prod"
      Project     = "nexora-telecom"
      ManagedBy   = "terraform"
    }
  }
}