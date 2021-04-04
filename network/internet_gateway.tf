resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.main_vpc.id
}

resource "aws_route_table" "internet_route" {
  vpc_id = aws_vpc.main_vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }
  lifecycle {
    ignore_changes = all
  }
  tags = {
    Name = "internet-route-table"
  }
}

resource "aws_main_route_table_association" "set-master-default-rt-assoc" {
  vpc_id         = aws_vpc.main_vpc.id
  route_table_id = aws_route_table.internet_route.id
}
