#######################################
#  AWS Provider
#######################################
provider "aws" {
  region = var.aws_region
}

#######################################
#  Data Sources (Default VPC + Subnets)
#######################################
data "aws_vpc" "default" {
  default = true
}

data "aws_subnets" "default_public" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.default.id]
  }
}

locals {
  vpc_id         = data.aws_vpc.default.id
  public_subnets = data.aws_subnets.default_public.ids
}

#######################################
#  EC2 MODULE
#######################################
module "ec2" {
  source = "./ec2"

  instance_type  = var.instance_type
  key_pair_name  = var.key_pair_name
  project_name   = var.project_name

  vpc_id         = local.vpc_id
  public_subnets = local.public_subnets
}

#######################################
#  ECS MODULE
#######################################
module "ecs" {
  source = "./ecs"

  project_name = var.project_name
  docker_image = var.docker_image
  app_port     = var.app_port

  # ECS should NOT depend on EC2 AMI directly unless required
  # If your ECS cluster runs on EC2, pass instance ID from EC2 module
  ecs_instance_id = module.ec2.instance_id
}

#######################################
#  RDS MODULE
#######################################
module "rds" {
  source = "./rds"

  project_name          = var.project_name
  rds_engine            = var.rds_engine
  rds_engine_version    = var.rds_engine_version
  rds_instance_class    = var.rds_instance_class
  rds_allocated_storage = var.rds_allocated_storage
  rds_username          = var.rds_username
  rds_password          = var.rds_password

  vpc_id = local.vpc_id
}

#######################################
#  ROUTE53 MODULE (Point DNS → EC2)
#######################################
module "route53" {
  source = "./route53"

  domain_name = var.domain_name
  subdomain   = var.subdomain

  # Public IP of EC2 instance created in EC2 module
  ec2_public_ip = module.ec2.public_ip
}
