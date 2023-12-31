 resource "aws_vpc" "my_vpc" {
  cidr_block = "10.0.0.0/16"
  tags = {
   name = "terra-vpc"
}
 }

resource "aws_subnet" "my_subnet" {
  vpc_id     = aws_vpc.my_vpc.id
  cidr_block = "10.0.0.0/24"
 availability_zone       = "ap-south-1a"
 tags = {
  name  =  "terra-subnet"
}
 }


