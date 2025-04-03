terraform {
  required_version = ">= 1.7.1"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 5.0"
    }
  }
  backend "s3" {
    bucket         = "tf-state-bucket-dvt-poc"
    key            = "lambda-hsn/terraform.tfstate"
    region         = "eu-central-1"
  }
}

provider "aws" {
  region = "eu-central-1"
  default_tags {
    tags = {
      managed_by = "GH_Terraform"
    }
  }
}
