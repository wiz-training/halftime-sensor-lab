resource "aws_instance" "attacker_instance" {
  ami           = "ami-0dc67873410203528"
  instance_type = "t2.medium"
  subnet_id     = module.vpc.public_subnets[0]
  key_name      = "attacker"

  tags = {
    Name = "Attacker Box"
  }
}

resource "aws_security_group" "attacker_security_group" {
  description = "Allow traffic only from NAT Gateway"
  vpc_id      = module.vpc.vpc_id

  ingress {
    from_port   = 1337
    to_port     = 1337
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "Attacker Security Group"
  }
}

resource "aws_network_interface_sg_attachment" "attacker_sg_attachment" {
  security_group_id    = aws_security_group.attacker_security_group.id
  network_interface_id = aws_instance.attacker_instance.primary_network_interface_id
}
