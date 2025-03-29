terraform {
  required_version = ">= 1.7.1"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 5.0"
    }
  }
  backend "s3" {
    bucket = "hsn-atlantis-bucket-vossloh"
    key    = "terraform.tfstate"
    region = "eu-central-1"
  }
}

provider "aws" {
  region = "eu-central-1"
  assume_role {
    role_arn = "arn:aws:iam::930736525289:role/AtlantisMemberRole"
  }
  default_tags {
    tags = {
      managed_by = "Terraform_atlantis"
    }
  }
}
