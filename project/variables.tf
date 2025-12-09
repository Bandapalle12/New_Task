#############################
# GLOBAL VARIABLES
#############################
variable "project_name" {
  description = "Project name prefix"
  type        = string
  default     = "three-tier-demo"
}

variable "aws_region" {
  description = "AWS region for all resources"
  type        = string
  default     = "us-east-1"
}

variable "vpc_id" {
  description = "Existing VPC ID (Free Tier recommended: default VPC)"
  type        = string
  default     = "" # provide your VPC manually OR data source
}

variable "public_subnets" {
  description = "List of public subnets"
  type        = list(string)
  default     = [] # fill using data sources for default VPC
}

#############################
# EC2 + ECS CLUSTER VARIABLES
#############################
variable "instance_type" {
  description = "EC2 instance type for ECS cluster"
  type        = string
  default     = "t2.micro" # free-tier eligible
}

variable "ecs_ami_id" {
  description = "ECS-optimized AMI ID"
  type        = string
  default     = "" # filled automatically via data source
}

variable "desired_capacity" {
  description = "Number of EC2 instances"
  type        = number
  default     = 1
}

#############################
# DOCKER APP VARIABLES
#############################
variable "docker_image" {
  description = "Docker image for ECS service"
  type        = string
  default     = "your-dockerhub-user/hello-world:latest"
}

variable "app_port" {
  description = "App container port"
  type        = number
  default     = 5000
}

#############################
# RDS VARIABLES
#############################
variable "rds_engine" {
  description = "Database Engine"
  type        = string
  default     = "mysql"
}

variable "rds_engine_version" {
  description = "Database Engine Version"
  type        = string
  default     = "8.0.33"
}

variable "rds_instance_class" {
  description = "RDS Instance Class (Free Tier eligible)"
  type        = string
  default     = "db.t3.micro"
}

variable "rds_allocated_storage" {
  description = "Allocated storage"
  type        = number
  default     = 20
}

variable "rds_username" {
  description = "Master username"
  type        = string
  default     = "admin"
}

variable "rds_password" {
  description = "Master password"
  type        = string
  sensitive   = true
  default     = "Test12345!"
}

#############################
# ROUTE53 VARIABLES
#############################
variable "domain_name" {
  description = "Hosted Zone domain name"
  type        = string
  default     = "example.com"
}

variable "subdomain" {
  description = "Subdomain for ECS service"
  type        = string
  default     = "app"
}
