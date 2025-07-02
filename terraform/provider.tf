terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "6.0.0"
    }
    random = {
      source  = "hashicorp/random"
      version = "~> 3.0"
    }
  }
}

terraform {
  backend "s3" {
    bucket         = "terraform-porsche-0107-2025"
    key            = "tfstate"
    region         = "eu-central-1"
    encrypt        = true
    dynamodb_table = "terraform-state-lock"
  }
}


provider "aws" {
  # Configuration options
  region = var.region
}