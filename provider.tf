terraform {
  required_version = ">= 1.7.1"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 5.0"
    }
  }
  backend "s3" {
    bucket = "tf-state-bucket-dvt-poc"
    key    = "test/terraform.tfstate"
    region = "eu-central-1"
    #role_arn = "arn:aws:iam::975050358414:role/AtlantisAssumeRole"
  }
}

provider "aws" {
  region = "eu-central-1"
  assume_role {
    role_arn = "arn:aws:iam::975050358414:role/AtlantisAssumeRole"
  }
  default_tags {
    tags = {
      managed_by = "Terraform_atlantis"
    }
  }
}
