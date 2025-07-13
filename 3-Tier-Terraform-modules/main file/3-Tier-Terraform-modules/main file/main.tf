terraform {
  required_version = "~> 1.1"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}
# Configure the AWS Provider
provider "aws" {
  region = "us-east-1"
}
module "vpc" {
  source   = "./modules/vpc"
  region   = var.region
  vpc_cidr = var.vpc_cidr
}

module "security" {
  source = "./modules/security"
  vpc_id = module.vpc.vpc_id
}

module "web" {
  source            = "./modules/web"
  public_subnets    = module.vpc.public_subnets
  ami_id            = var.web_ami
  instance_type     = var.web_instance_type
  security_group_id = module.security.web_sg_id
}

module "app" {
  source            = "./modules/app"
  private_subnets   = module.vpc.app_subnets
  ami_id            = var.app_ami
  instance_type     = var.app_instance_type
  security_group_id = module.security.app_sg_id
}

module "db" {
  source            = "./modules/db"
  db_subnets        = module.vpc.db_subnets
  db_username       = var.db_username
  db_password       = var.db_password
  security_group_id = module.security.db_sg_id
}
