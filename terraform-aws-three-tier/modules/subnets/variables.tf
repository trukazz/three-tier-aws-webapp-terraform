variable "vpc_id" {
  description = "ID of the VPC where subnets will be created"
  type        = string
}

variable "subnets" {
  type = map(object({
    cidr_block = string
    az         = string
    public     = bool
  }))
}
