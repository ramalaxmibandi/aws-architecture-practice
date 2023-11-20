provider "aws" {


  region = "eu-west-2"
  profile = "Terraform-admin"

}
 terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }

  required_version = ">= 0.14.9"
 }

  