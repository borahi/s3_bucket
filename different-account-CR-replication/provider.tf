terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "~> 3.0"
    }
  }
}

provider "aws" {
  alias = "source"
  region = "us-east-1"
  profile = var.source_account
}

provider "aws" {
  alias = "destination"
  region = "us-east-1"
  profile = var.destination_account
}