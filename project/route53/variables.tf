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