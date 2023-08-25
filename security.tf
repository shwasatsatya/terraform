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



