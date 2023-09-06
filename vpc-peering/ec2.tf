
resource "aws_key_pair" "my_keypair" {
  key_name   = "ec2-key"
  public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQDBwtvlmC2jJgnk+w5Z7zAReenr9buK4Qr4Jsr6OxpRnEv97T5aiH0PUJDAKB+6h8QdRe2pzFvK0waXuUS5z6nxzjHXG9lmVZBfG7bN1IRQeE11l/qnP+z65ZZPaRYOdPtKAvqDziNlNI84Gz0e00OtRqxRUVywS0UcSyvM+L64p9O/vBOgGXwNtGdfXOic2cB7nzWEjCHQMpstfrACrhPO4mplohh0qRxOGL75ppXF0WiTg0Gl5pxNmgxGm9t9S+WPW3wgWSkDZZ1piKCKPKWEfY/+TFmiA8vZS9btJJx8MRKUEOPVXifsOjWCbmSqbkQJGYKQihCPGpwd93brSobpD6h+4C37LGmmkUtKEkii4xjFKM3GJdcii+7Z3EVJWUp57PaOFqxqkrYgjh/lsA/ViuFGUInlIsffnzRII7/jS+RJqf6DCBiwVsvvoBEAeiQl3M3wknCwIfcaq2FsYwT5SVRnmJtcLaG+zmPXo5erPUQJ+ZNFKTK2/4VaCgTdz/E= ec2-user@ip-10-0-0-111.ap-south-1.compute.internal"
}

resource "aws_key_pair" "my_keypair-1" {
provider  = aws.central
  key_name   = "ec2-key-1"
  public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQC0Vlj4JhLjhMRMRNy81ZjFnbljTx6hbeYapmxPzo6c1kBGpdoQXGyl5/Wz1BOw6/WKI3pGC6OR8r+KZacWdjsbST3JBEFYmfoq1n854dv+FXxge1yirUjZxoDGC90TcreIJMEra+V+peJsuab/e0DicB8k83OxvzJJgJRoX9HAb0Gfy8isICC0Mu9On+ze/dM+lVJSzbnldD5T9EifX95uFzvgQkyyxhhCsYGoudbImLtP2JaSjUKn/HzJgs0TU4tZPQW6vcXvV/bLXhAtEufTvHCoygBzHBFm4SxBbRIMee9xiBfLEaY5WVutzyGh7xGeGXWXDByPuhvIhA68ciDYlwnKLrtxZh9ok5ZWoITjaNEeEG9saFP8A9xmBC9XH1LGQv/c0sacoltLSRKYiMrlsdRgor36IZ0OSw1RsgqEdAR+Qhu1YqdXhlaosJotdyaSX2cWkAaChSfpUqpk4wKrmyrzJbuVSdUULDi+KqCwBcekW7OsAf1odXqC22qN//E= ubuntu@ip-10-0-0-8"
}

# vpc for ap-south
 resource "aws_vpc" "my_vpc" {
  cidr_block = "10.0.0.0/16"
  tags = {
    Name = "terra-vpc"
   } 
 }

#subnet for ap-south
resource "aws_subnet" "my_subnet" {
  vpc_id     = aws_vpc.my_vpc.id
  cidr_block = "10.0.0.0/24"
 availability_zone       = "ap-south-1a"
 tags = {
  Name  =  "terra-subnet"
   }
 }

#vpc for us-east
resource "aws_vpc" "my_vpc-1" {
provider  = aws.central
  cidr_block = "172.31.0.0/16"
  tags = {
  Name = "terra-vpc-1"
   }
 }

#pvt subnet for us-east
resource "aws_subnet" "my_subnet-pvt" {
provider  = aws.central
  vpc_id     = aws_vpc.my_vpc-1.id
  cidr_block = "172.31.0.0/24"
 availability_zone       = "us-east-1a"
 tags = {
  Name  =  "terra-subnet-pvt"
   }
 }

#pub subnet for us-east
resource "aws_subnet" "my_subnet-pub" {
provider  = aws.central
  vpc_id     = aws_vpc.my_vpc-1.id
  cidr_block = "172.31.1.0/24"
 availability_zone       = "us-east-1b"
 tags = {
  Name  =  "terra-subnet-pub"
   }
 }

#security for ap-south
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


ingress {
    from_port   = -1
    to_port     = -1
    protocol    = "ICMP"
    cidr_blocks = ["0.0.0.0/0"]
   }

   egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
  }
}

#security for us-east
resource "aws_security_group" "my_sg-1" {
provider  =  aws.central
  name_prefix = "my-ec2-sg-"
  vpc_id      = aws_vpc.my_vpc-1.id
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


ingress {
    from_port   = -1
    to_port     = -1
    protocol    = "ICMP"
    cidr_blocks = ["0.0.0.0/0"]
   }

   egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
  }
}

#igw for ap-south
resource "aws_internet_gateway" "my_igw" {
  vpc_id = aws_vpc.my_vpc.id
  tags  = {
  Name  = "terra-igw"
    }
  }


#route-table for ap-south
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

#igw foe us-east
resource "aws_internet_gateway" "my_igw-1" {
provider  = aws.central
  vpc_id = aws_vpc.my_vpc-1.id
  tags  = {
  Name  = "terra-igw"
    }
  }

#rt for us-east
resource "aws_route_table" "my_rt-1" {
provider  = aws.central
  vpc_id = aws_vpc.my_vpc-1.id
route {
cidr_block ="0.0.0.0/0"
 nat_gateway_id             = aws_nat_gateway.nat-1.id
   }
tags  = {
 Name  =  "terra-pvt-rt"
  
  }
 }


resource "aws_route_table_association" "natgateway-a" {
provider  = aws.central
  subnet_id      = aws_subnet.my_subnet-pvt.id
  route_table_id = aws_route_table.my_rt-1.id
}


resource "aws_route_table" "my_rt-pub" {
provider  = aws.central
  vpc_id = aws_vpc.my_vpc-1.id
route {
 cidr_block ="0.0.0.0/0"
gateway_id  = aws_internet_gateway.my_igw-1.id
    }
tags  = {
Name  = "terra-pub-rt"

}
 }


resource "aws_route_table_association" "internet-gateway-a" {
provider  = aws.central
  subnet_id      = aws_subnet.my_subnet-pub.id
  route_table_id = aws_route_table.my_rt-pub.id
}

resource "aws_nat_gateway" "nat-1" {
provider  =aws.central
  subnet_id         = aws_subnet.my_subnet-pub.id
allocation_id =   aws_eip.terra-eip.id
}


resource "aws_instance" "web" {
ami           = "ami-0f5ee92e2d63afc18"
  instance_type = "t2.micro"
  subnet_id     = aws_subnet.my_subnet.id
  key_name      = aws_key_pair.my_keypair.id
  security_groups = [aws_security_group.my_sg.id]
  tags  =  {
     Name     = "terra-ec2"
    }
  }

resource "aws_instance" "server1" {
provider  = aws.central
ami           = "ami-053b0d53c279acc90"
  instance_type = "t2.micro"
  subnet_id     = aws_subnet.my_subnet-pvt.id
  key_name      = aws_key_pair.my_keypair-1.id
  security_groups = [aws_security_group.my_sg-1.id]


  tags  =  {
     Name     = "vpc-peering-server"
     }
  }

resource "aws_eip" "lb" {
 instance  = aws_instance.web.id
  domain   = "vpc"
 
}


resource "aws_eip" "terra-eip" {
provider  = aws.central

  domain  = "vpc"
}

resource "aws_vpc_peering_connection" "mumbai-peer-nverg" {
  peer_owner_id = "974759471018"
  peer_vpc_id   = aws_vpc.my_vpc-1.id
  vpc_id        = aws_vpc.my_vpc.id
  peer_region   = "us-east-1"


  tags   = { 
  Name   =  "mumbai-to-nverg"
        }
}

resource "aws_vpc_peering_connection_accepter" "peer-mumbai" {
  provider                  = aws.central
  vpc_peering_connection_id = aws_vpc_peering_connection.mumbai-peer-nverg.id
  auto_accept               = true

  tags = {
    Side = "Accepter"
  }
}


resource "aws_route" "vpc-mum-nver" {
  route_table_id            = aws_route_table.my_rt.id
  destination_cidr_block    = "172.31.0.0/16"
  vpc_peering_connection_id = aws_vpc_peering_connection.mumbai-peer-nverg.id
}

resource "aws_route" "vpc-nverg-mumbai" {
provider   = aws.central
  route_table_id            = aws_route_table.my_rt-1.id
  destination_cidr_block    = "10.0.0.0/16"
  vpc_peering_connection_id = aws_vpc_peering_connection.mumbai-peer-nverg.id
}


