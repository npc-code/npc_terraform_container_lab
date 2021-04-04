resource "aws_eip" "nat_gw_eip" {
  count = local.num_nats
}

resource "aws_nat_gateway" "nat_gws_best_practice" {
    count = local.num_nats == 1 ? 0 : local.num_nats
    allocation_id = element(aws_eip.nat_gw_eip.*.id, count.index)
    subnet_id = element(aws_subnet.public_subnets.*.id, count.index)
}

resource "aws_route_table_association" "private_routes_best_practice" {
    count = local.num_nats == 1 ? 0 : local.num_nats
    subnet_id = element(aws_subnet.private_subnets.*.id, count.index)
    route_table_id = element(aws_route_table.private_best_practice.*.id, count.index)
}

resource "aws_route_table" "private_best_practice" {
    count = local.num_nats == 1 ? 0 : local.num_nats
    vpc_id = aws_vpc.main_vpc.id
    route {
      cidr_block = "0.0.0.0/0"
      nat_gateway_id = element(aws_nat_gateway.nat_gws_best_practice.*.id, count.index)
    }

    tags = {
      Name = "private-route-${count.index}"
    }
}

resource "aws_nat_gateway" "minimal_nat_gateway" {
    count = var.nat_gw_production ? 0 : 1
    allocation_id = aws_eip.nat_gw_eip.0.id
    subnet_id = aws_subnet.public_subnets.0.id   
}

resource "aws_route_table_association" "minimal_private_route_assoc" {
    count = var.nat_gw_production ? 0 : local.num_subnets
    subnet_id = element(aws_subnet.private_subnets.*.id, count.index)
    route_table_id = aws_route_table.minimal_private_route_table.0.id
}

resource "aws_route_table" "minimal_private_route_table" {
  count = var.nat_gw_production ? 0 : 1
  vpc_id = aws_vpc.main_vpc.id
  route {
      cidr_block = "0.0.0.0/0"
      nat_gateway_id = aws_nat_gateway.minimal_nat_gateway.0.id
  }

  tags = {
    Name = "private-route"
  }
}
