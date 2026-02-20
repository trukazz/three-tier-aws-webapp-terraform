variable "public_subnet_ids" {
  description = "Map of public subnet IDs"
  type        = map(string)
}

variable "alb_sg_id" {
  description = "Security group ID for the ALB"
  type        = string
}

variable "vpc_id" {
  description = "VPC ID"
  type        = string
}

variable "vpc_name" {
  description = "Name prefix for ALB resources"
  type        = string
}
