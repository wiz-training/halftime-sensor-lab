# resource "aws_instance" "attacker_instance" {
#   ami           = "ami-0dc67873410203528"
#   instance_type = "t3.large"
#   subnet_id     = module.vpc.public_subnets[0]
#   key_name      = aws_key_pair.attacker_key_pair.key_name
#   user_data     = <<-EOF
#               #!/bin/bash

#               set -x

#               # Update the package list and install necessary tools
#               yum update -y
#               yum install -y wget tar nc

#               # Download the Go binary tarball
#               wget https://go.dev/dl/go1.22.5.linux-amd64.tar.gz -P /tmp

#               # Remove any previous Go installation
#               rm -rf /usr/local/go

#               # Extract the tarball to the installation path
#               tar -C /usr/local -xzf /tmp/go1.22.5.linux-amd64.tar.gz

#               # Set up the Go environment variables
#               echo "export PATH=\$PATH:/usr/local/go/bin" >> /etc/profile
#               source /etc/profile

#               # Verify Go installation
#               go version

#               go install github.com/neex/phuip-fpizdam@latest

#               EOF

#   tags = {
#     Name = "Attacker Box"
#   }
# }

# resource "tls_private_key" "attacker_pem" {
#   algorithm = "RSA"
#   rsa_bits  = 2048
# }

# resource "aws_key_pair" "attacker_key_pair" {
#   key_name   = "attacker_key_pair"
#   public_key = tls_private_key.attacker_pem.public_key_openssh
# }

# resource "local_sensitive_file" "private_key" {
#   content  = tls_private_key.attacker_pem.private_key_pem
#   filename = "${path.module}/../attacker.pem"
# }

# resource "aws_security_group" "attacker_security_group" {
#   description = "Allow traffic only from NAT Gateway"
#   vpc_id      = module.vpc.vpc_id

#   ingress {
#     from_port   = 1337
#     to_port     = 1337
#     protocol    = "tcp"
#     cidr_blocks = ["0.0.0.0/0"]
#   }

#   ingress {
#     from_port   = 22
#     to_port     = 22
#     protocol    = "tcp"
#     cidr_blocks = ["0.0.0.0/0"]
#   }

#   egress {
#     from_port   = 0
#     to_port     = 0
#     protocol    = "-1"
#     cidr_blocks = ["0.0.0.0/0"]
#   }

#   tags = {
#     Name = "Attacker Security Group"
#   }
# }

# resource "aws_network_interface_sg_attachment" "attacker_sg_attachment" {
#   security_group_id    = aws_security_group.attacker_security_group.id
#   network_interface_id = aws_instance.attacker_instance.primary_network_interface_id
# }
