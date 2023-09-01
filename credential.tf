terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "random" {}

##provider ap-south-1
provider "aws" {
  region     = "ap-south-1"
  access_key = ""
  secret_key = ""
}

##provider us-east-1
provider "aws" {
  alias  = "central"
  region = "us-east-1"
access_key=  ""
  secret_key = ""
 }
