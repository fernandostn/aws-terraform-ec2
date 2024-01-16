terraform {
  required_version = ">=1.0.3"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "5.27.0"
    }
  }

  backend "s3" {
    bucket = "fss-remotestate2"
    key    = "aws/terraform.tfstate"
    region = var.region_project
  }
}

provider "aws" {
  region = var.region_project

  default_tags {
    tags = {
      owner      = var.owner_project
      managed-by = var.managed_by_project
    }
  }
}

module "network" {
  source = "./modules/network"

  vpc_cidr = var.vpc_cidr_project
  az_count = var.az_count_project

}

module "ec2" {
  source = "./modules/ec2"

  subnet        = module.network.subnet_public_id[0]
  sg            = module.network.sg_public_id
  instance_type = var.instance_type_project
}

module "db" {
  source = "./modules/db"

  subnet0  = module.network.subnet_private_db_id[0]
  subnet1  = module.network.subnet_private_db_id[1]
  sg       = module.network.sg_private_db_id
  az_count = var.az_count_project
}