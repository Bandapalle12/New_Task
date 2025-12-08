############################################
# PROVIDERS
############################################
provider "aws" {
  region = var.aws_region
}

############################################
# DATA SOURCES (Default VPC + Subnets)
############################################
# Use default VPC (free-tier & simplest)
data "aws_vpc" "default" {
  default = true
}

data "aws_subnets" "default_public" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.default.id]
  }
}

############################################
# LOCALS
############################################
locals {
  vpc_id        = data.aws_vpc.default.id
  public_subnets = data.aws_subnets.default_public.ids
}

############################################
# MODULE: EC2 Instance for ECS Cluster
############################################
module "ec2" {
  source = "./ec2"

  instance_type  = var.instance_type
  key_pair_name  = var.key_pair_name

  vpc_id         = local.vpc_id
  public_subnets = local.public_subnets

  project_name   = var.project_name
}

############################################
# MODULE: ECS Cluster + Task + Service
############################################
module "ecs" {
  source = "./ecs"

  project_name   = var.project_name
  docker_image   = var.docker_image
  app_port       = var.app_port

  # ECS cluster EC2 instance
  ecs_instance_id = module.ec2.ecs_instance_id
}

############################################
# MODULE: RDS Database
############################################
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

############################################
# MODULE: Route 53 DNS → EC2 Instance
############################################
module "route53" {
  source = "./route53"

  domain_name = var.domain_name
  subdomain   = var.subdomain

  # Map DNS → EC2 public IP (NO ALB)
  ec2_public_ip = module.ec2.ecs_public_ip
}

############################################
# OUTPUTS
############################################
output "app_url" {
  value = "http://${var.subdomain}.${var.domain_name}"
}

output "ec2_public_ip" {
  value = module.ec2.ecs_public_ip
}

output "rds_endpoint" {
  value = module.rds.rds_endpoint
}
