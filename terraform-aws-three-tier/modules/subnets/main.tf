resource "aws_subnet" "this" {
  for_each                = var.subnets
  cidr_block              = each.value.cidr_block
  vpc_id                  = var.vpc_id
  availability_zone       = each.value.az
  map_public_ip_on_launch = each.value.public
}
