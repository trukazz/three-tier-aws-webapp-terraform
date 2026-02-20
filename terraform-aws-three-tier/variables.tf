variable "vpc_cidr" {
  description = "vpc cidr block"
  type        = string

}

variable "vpc_name" {
  type = string
}


variable "subnets" {
  type = map(object({
    cidr_block = string
    az         = string
    public     = bool
  }))
}
