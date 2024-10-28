provider "aws" {
  region = "us-east-1"
}

resource "aws_vpc" "day-1-vpc" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_hostnames = "true"

  tags = {
    Name = "day-1-vpc" # Changed 'name' to 'Name'
  }
}

resource "aws_internet_gateway" "day-1-IGW" {
  vpc_id = aws_vpc.day-1-vpc.id
  tags = {
    Name = "day-1-IGW" # Changed 'name' to 'Name'
  }
}

resource "aws_subnet" "day-1-Pub-Sub" {
  vpc_id     = aws_vpc.day-1-vpc.id
  cidr_block = "10.0.1.0/24"

  tags = {
    Name = "day-1-Pub-Sub" # Changed 'name' to 'Name'
  }
}

resource "aws_route_table" "day-1-pub-rt" {
  vpc_id = aws_vpc.day-1-vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.day-1-IGW.id
  }

  tags = {
    Name    = "day-1-rt" # Changed 'name' to 'Name'
    service = "terraform"
  }
}

resource "aws_route_table_association" "day-1-pub-rta" {
  subnet_id      = aws_subnet.day-1-Pub-Sub.id
  route_table_id = aws_route_table.day-1-pub-rt.id
}

resource "aws_security_group" "day-1-sg" {
  name        = "day-1-sg"
  description = "Allow TLS inbound traffic and all outbound traffic"
  vpc_id      = aws_vpc.day-1-vpc.id

  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "day-1-sg" # Changed 'name' to 'Name'
  }
}

