// Core terraform details. No need to change any of this.

terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.0"
    }
  }
}

provider "aws" {
  region                  = local.aws_region
  shared_credentials_file = "~/.aws/credentials"
  profile                 = "ksaa"
}
