resource "aws_instance" "web" {  
ami           = "ami-0f5ee92e2d63afc18"
  instance_type = "t2.micro"
  subnet_id     = aws_subnet.my_subnet.id
  key_name      = aws_key_pair.my_keypair.id
  security_groups = [aws_security_group.my_sg.id]
  tags  =  {
     name     = "terra-ec2"
}
  }
