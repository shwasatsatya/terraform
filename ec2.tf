resource "aws_key_pair" "my_keypair" {
  key_name   = "ec2-key"
  public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQDBwtvlmC2jJgnk+w5Z7zAReenr9buK4Qr4Jsr6OxpRnEv97T5aiH0PUJDAKB+6h8QdRe2pzFvK0waXuUS5z6nxzjHXG9lmVZBfG7bN1IRQeE11l/qnP+z65ZZPaRYOdPtKAvqDziNlNI84Gz0e00OtRqxRUVywS0UcSyvM+L64p9O/vBOgGXwNtGdfXOic2cB7nzWEjCHQMpstfrACrhPO4mplohh0qRxOGL75ppXF0WiTg0Gl5pxNmgxGm9t9S+WPW3wgWSkDZZ1piKCKPKWEfY/+TFmiA8vZS9btJJx8MRKUEOPVXifsOjWCbmSqbkQJGYKQihCPGpwd93brSobpD6h+4C37LGmmkUtKEkii4xjFKM3GJdcii+7Z3EVJWUp57PaOFqxqkrYgjh/lsA/ViuFGUInlIsffnzRII7/jS+RJqf6DCBiwVsvvoBEAeiQl3M3wknCwIfcaq2FsYwT5SVRnmJtcLaG+zmPXo5erPUQJ+ZNFKTK2/4VaCgTdz/E= ec2-user@ip-10-0-0-111.ap-south-1.compute.internal"
}

resource "aws_vpc" "my_vpc" {
  cidr_block = "10.0.0.0/16"
  tags = {
    Name = "terra-vpc"
   }
 }


resource "aws_subnet" "my_subnet" {
  vpc_id     = aws_vpc.my_vpc.id
  cidr_block = "10.0.0.0/24"
 availability_zone       = "ap-south-1a"
 tags = {
  Name  =  "terra-subnet"
   }
 }

resource "aws_subnet" "my_subnet-pvt" {
  vpc_id     = aws_vpc.my_vpc.id
  cidr_block = "10.0.1.0/24"
 availability_zone       = "ap-south-1b"
 tags = {
  Name  =  "terra-subnet-pvt"
   }
 }

resource "aws_security_group" "my_sg" {
  name_prefix = "my-ec2-sg-"
  vpc_id      = aws_vpc.my_vpc.id
  description = "Allow all inbound and outbound traffic"

  // Define inbound and outbound rules as needed
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
   }

   # Ingress rule to allow all inbound traffic
  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"  # Use -1 to represent all protocols
    cidr_blocks = ["0.0.0.0/0"]  # Allow traffic from all IP addresses
  }



   egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
  }
}


resource "aws_internet_gateway" "my_igw" {
  vpc_id = aws_vpc.my_vpc.id
  tags  = {
  Name  = "terra-igw"
    }
  }


resource "aws_route_table" "my_rt" {
  vpc_id = aws_vpc.my_vpc.id

route {
cidr_block ="0.0.0.0/0"
gateway_id = aws_internet_gateway.my_igw.id
}
tags  = {
 Name  =  "terra-route-table"

}
 }


resource "aws_route_table_association" "a" {
  subnet_id      = aws_subnet.my_subnet.id
  route_table_id = aws_route_table.my_rt.id
}


resource "aws_nat_gateway" "nat" {
  subnet_id         = aws_subnet.my_subnet.id
allocation_id =   aws_eip.terra-eip.id
}


resource "aws_eip" "terra-eip" {

  domain  = "vpc"
}

resource "aws_route_table" "my_rt-1" {
  vpc_id = aws_vpc.my_vpc.id
route {
cidr_block ="0.0.0.0/0"
 nat_gateway_id             = aws_nat_gateway.nat.id
   }
tags  = {
 Name  =  "terra-pvt-rt"

  }
 }


resource "aws_route_table_association" "natgateway-a" {
  subnet_id      = aws_subnet.my_subnet-pvt.id
  route_table_id = aws_route_table.my_rt-1.id
}

resource "aws_eip" "pub-ec2" {
 instance  = aws_instance.pub-ec2.id
  domain   = "vpc"

}


resource "aws_instance" "pub-ec2" {
ami           = "ami-0f5ee92e2d63afc18"
  instance_type = "t2.micro"
  subnet_id     = aws_subnet.my_subnet.id
  key_name      = "ec2-key"
  security_groups = [aws_security_group.my_sg.id]
  tags  =  {
     Name     = "pub-machine"
    }
  }

resource "aws_instance" "pvt-ec2" {
ami           = "ami-0f5ee92e2d63afc18"
  instance_type = "t2.micro"
  subnet_id     = aws_subnet.my_subnet-pvt.id
  key_name      = "ec2-key"
  security_groups = [aws_security_group.my_sg.id]
  tags  =  {
     Name     = "pvt-machine"
    }
  }

