variable "project_name" {
  description = "Project name prefix"
  type        = string
  default     = "three-tier-demo"
}

variable "public_subnets" {
  description = "List of public subnets"
  type        = list(string)
  default     = [] # fill using data sources for default VPC
}

variable "instance_type" {
  description = "EC2 instance type for ECS cluster"
  type        = string
  default     = "t2.micro" # free-tier eligible
}

