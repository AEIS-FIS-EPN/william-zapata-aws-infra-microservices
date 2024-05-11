provider "aws" {
  shared_config_files      = ["C:/Users/zapat/.aws/config"]
  shared_credentials_files = ["C:/Users/zapat/.aws/credentials"]
}

// Enable IPv6 on the VPC
resource "aws_vpc" "fis_vpc" {
  cidr_block                       = "10.0.0.0/16"
  assign_generated_ipv6_cidr_block = true
}

// Public subnet
resource "aws_subnet" "public_subnet" {
  vpc_id                  = aws_vpc.fis_vpc.id
  cidr_block              = "10.0.1.0/24"
  ipv6_cidr_block         = cidrsubnet(aws_vpc.fis_vpc.ipv6_cidr_block, 8, 1)
  map_public_ip_on_launch = true
}

// Private subnet
resource "aws_subnet" "private_subnet" {
  vpc_id          = aws_vpc.fis_vpc.id
  cidr_block      = "10.0.2.0/24"
  ipv6_cidr_block = cidrsubnet(aws_vpc.fis_vpc.ipv6_cidr_block, 8, 2)
}

// Internet Gateway
resource "aws_internet_gateway" "fis_public_internet_gateway" {
  vpc_id = aws_vpc.fis_vpc.id
}

// Route table for public subnet
resource "aws_route_table" "fis_public_subnet_route_table" {
  vpc_id = aws_vpc.fis_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.fis_public_internet_gateway.id
  }

  route {
    ipv6_cidr_block = "::/0"
    gateway_id      = aws_internet_gateway.fis_public_internet_gateway.id
  }
}

// Association of route table with public subnet
resource "aws_route_table_association" "fis_public_association" {
  route_table_id = aws_route_table.fis_public_subnet_route_table.id
  subnet_id      = aws_subnet.public_subnet.id
}

// Security Group
resource "aws_security_group" "web_server_sg" {
  vpc_id = aws_vpc.fis_vpc.id

  ingress {
    description = "Allow HTTP trafic from internet"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "Allow HTTPS trafic from internet"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    description      = "Allow all trafic"
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }


  tags = {
    Name = "aeis security"
  }
}

// AMI Images
/*
    This code block looks for the latest Ubuntu 20.04 AMI 
    for HVM instances with SSD storage, owned by Canonical
*/
data "aws_ami" "ubuntu" {
  most_recent = "true"
  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["099720109477"] # Canonical
}

// Instance EC2 
resource "aws_instance" "ubuntu_aeis_instance" {
  ami           = data.aws_ami.ubuntu.id
  instance_type = "t2.micro"
  subnet_id     = aws_subnet.public_subnet.id
}

