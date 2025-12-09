variable "project_name" {
  description = "Project name prefix"
  type        = string
  default     = "three-tier-demo"
}

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

