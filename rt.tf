resource "aws_route_table" "my_rt" {
  vpc_id = aws_vpc.my_vpc.id
route {
cidr_block ="0.0.0.0/0"
 gateway_id             = aws_internet_gateway.my_igw.id
}
}


resource "aws_route_table_association" "a" {
  subnet_id      = aws_subnet.my_subnet.id
  route_table_id = aws_route_table.my_rt.id
}

