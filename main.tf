provider "aws" {
  region = var.aws_region
}


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
  vpc_id        = data.aws_vpc.default.id
  public_subnets = data.aws_subnets.default_public.ids
}


module "ec2" {
  source = "./ec2"

  instance_type  = var.instance_type
  key_pair_name  = var.key_pair_name

  vpc_id         = local.vpc_id
  public_subnets = local.public_subnets

  project_name   = var.project_name
}


module "ecs" {
  source = "./ecs"

  project_name   = var.project_name
  docker_image   = var.docker_image
  app_port       = var.app_port

  # ECS cluster EC2 instance
  ecs_instance_id = module.ec2.ecs_instance_id
}


module "rds" {
  source = "./rds"

  project_name        = var.project_name
  rds_engine          = var.rds_engine
  rds_engine_version  = var.rds_engine_version
  rds_instance_class  = var.rds_instance_class
  rds_allocated_storage = var.rds_allocated_storage
  rds_username        = var.rds_username
  rds_password        = var.rds_password

  vpc_id = local.vpc_id
}


module "route53" {
  source = "./route53"

  domain_name = var.domain_name
  subdomain   = var.subdomain

  # Map DNS → EC2 public IP (NO ALB)
  ec2_public_ip = module.ec2.ecs_public_ip
}

