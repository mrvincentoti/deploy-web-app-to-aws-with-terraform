terraform {
  # Assumes s3 bucket and dynamo DB table already set up
  # See /code/03-basics/aws-backend
  backend "s3" {
    bucket         = "devops-directive-tf-state-12345678"
    key            = "06-organization-and-modules/web-app/terraform.tfstate"
    region         = "us-east-1"
    dynamodb_table = "terraform-state-locking"
    encrypt        = true
  }

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.0"
    }
  }
}

provider "aws" {
  region = "us-east-1"
}

variable "db_pass" {
  description = "password for database #1"
  type        = string
  sensitive   = true
}

module "web_app" {
  source = "../module"

  # Input Variables
  bucket_name      = "web-app-1-devops-directive-web-app-data"
  domain           = "devopsdeployed.com"
  app_name         = "web-app"
  environment_name = "development"
  instance_type    = "t2.small"
  create_dns_zone  = true
  db_name          = "webappdb"
  db_user          = "foo"
  db_pass          = var.db_pass
}