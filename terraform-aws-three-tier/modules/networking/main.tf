########################################################
# NAT, EIP AND IGW
########################################################

resource "aws_internet_gateway" "web_igw" {
  vpc_id = var.vpc_id

  tags = {
    Name = "${var.vpc_name}-igw"
  }
}

resource "aws_eip" "nat_eip" {
  for_each = var.public_subnet_ids
  domain   = "vpc"

  tags = {
    Name = "${var.vpc_name}-eip-${each.key}"
  }
}

resource "aws_nat_gateway" "nat" {
  for_each      = var.public_subnet_ids
  allocation_id = aws_eip.nat_eip[each.key].id
  subnet_id     = each.value

  tags = {
    Name = "${var.vpc_name}-nat-${each.key}"
  }
}

############################################################
# AWS ROUTE TABLE SETTINGS
############################################################

resource "aws_route_table" "public" {
  vpc_id = var.vpc_id

  tags = {
    Name = "${var.vpc_name}-public-rt"
  }
}

resource "aws_route_table" "private" {
  for_each = var.private_subnet_ids
  vpc_id   = var.vpc_id

  tags = {
    Name = "${var.vpc_name}-private-rt-${each.key}"
  }
}

resource "aws_route" "public_internet_route" {
  route_table_id         = aws_route_table.public.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.web_igw.id
}

resource "aws_route_table_association" "public_rt_assoc" {
  for_each       = var.public_subnet_ids
  subnet_id      = each.value
  route_table_id = aws_route_table.public.id
}

resource "aws_route" "private_internet_route" {
  for_each               = var.private_subnet_ids
  route_table_id         = aws_route_table.private[each.key].id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.nat[keys(var.public_subnet_ids)[0]].id

}

resource "aws_route_table_association" "private_rt_assoc" {
  for_each       = var.private_subnet_ids
  subnet_id      = each.value
  route_table_id = aws_route_table.private[each.key].id
}
