variable "vpc_id" {
  type = string
}

variable "private_subnet_ids" {
  type = map(string)
}

variable "ec2_sg_id" {
  type = string
}

variable "target_group_arn" {
  type = string
}

variable "vpc_name" {
  type = string
}

variable "db_endpoint" {
  type = string
}

variable "db_username" {
  type = string
}

variable "db_password" {
  type = string
}
