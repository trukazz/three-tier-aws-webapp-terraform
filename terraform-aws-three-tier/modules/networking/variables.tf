variable "vpc_id" {
  type = string
}

variable "public_subnet_ids" {
  type = map(string)
}

variable "private_subnet_ids" {
  type = map(string)
}

variable "vpc_name" {
  type = string
}
