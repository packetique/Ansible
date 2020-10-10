
provider "aws" {
  region = "eu-central-1"
}

# Create new vpc
resource "aws_vpc" "ansible_vpc" {
  cidr_block                       = "172.31.0.0/16"
  enable_dns_support               = "true"
  enable_dns_hostnames             = "true"
  assign_generated_ipv6_cidr_block = "false"
  tags = {
    Name = "ansible-vpc"
  }
}

# Create new security group
resource "aws_security_group" "ansible_SG" {
  name        = "ansible_SG"
  description = "Ansible security group"
  vpc_id      = aws_vpc.ansible_vpc.id

  # allow traffic for TCP 22
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # allow traffic for TCP 80
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # allow all outcoming traffic
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# Create public subnet
resource "aws_subnet" "ansible_subnet_public" {
  cidr_block              = "172.31.1.0/24"
  vpc_id                  = aws_vpc.ansible_vpc.id
  map_public_ip_on_launch = "true"
  availability_zone       = "eu-central-1a"
  tags = {
    Name = "ansible_subnet_public"
  }
}

# Create gateway
resource "aws_internet_gateway" "ansible_internet_gateway" {
  vpc_id = aws_vpc.ansible_vpc.id
  tags = {
    Name = "internet-gateway"
  }
}

# Create route table
resource "aws_route_table" "ansible_route_table" {
  vpc_id = aws_vpc.ansible_vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.ansible_internet_gateway.id
  }
  tags = {
    Name = "internet_gateway-default"
  }
}

# Create route table association for public subnet
resource "aws_route_table_association" "ansible_route_table_association_public" {
  subnet_id      = aws_subnet.ansible_subnet_public.id
  route_table_id = aws_route_table.ansible_route_table.id
}

# Create EC2 instance with Ubuntu 18
resource "aws_instance" "ubuntu_18" {
  ami                         = "ami-0d359437d1756caa8"
  instance_type               = "t2.micro"
  key_name                    = "frankfurt"
  associate_public_ip_address = true
  vpc_security_group_ids      = [aws_security_group.ansible_SG.id]
  subnet_id                   = aws_subnet.ansible_subnet_public.id
  tags = {
    Name    = "Ubuntu 18"
    Owner   = "Mikhail Volov"
    Project = "Ansible learning"
  }
}

# Create EC2 instance with Red Hat 8
resource "aws_instance" "red_hat_8" {
  ami                         = "ami-07dfba995513840b5"
  instance_type               = "t2.micro"
  key_name                    = "frankfurt"
  associate_public_ip_address = true
  vpc_security_group_ids      = [aws_security_group.ansible_SG.id]
  subnet_id                   = aws_subnet.ansible_subnet_public.id
  tags = {
    Name    = "Red Hat 8"
    Owner   = "Mikhail Volov"
    Project = "Ansible learning"
  }
}

# Create EC2 instance with Amazon Linux 2
resource "aws_instance" "amazon_linux_2" {
  ami                         = "ami-0c115dbd34c69a004"
  instance_type               = "t2.micro"
  key_name                    = "frankfurt"
  associate_public_ip_address = true
  vpc_security_group_ids      = [aws_security_group.ansible_SG.id]
  subnet_id                   = aws_subnet.ansible_subnet_public.id
  tags = {
    Name    = "Amazon Linux 2"
    Owner   = "Mikhail Volov"
    Project = "Ansible learning"
  }
}

output "Ubuntu_ip" {
  value = aws_instance.ubuntu_18.public_ip
}

output "amazon_ip" {
  value = aws_instance.amazon_linux_2.public_ip
}

output "redhat_ip" {
  value = aws_instance.red_hat_8.public_ip
}
