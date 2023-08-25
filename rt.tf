resource "aws_route_table" "my_rt" {
  vpc_id = aws_vpc.my_vpc.id
}

resource "aws_route" "my_route" {
  route_table_id         = aws_route_table.my_rt.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.my_igw.id

 }
