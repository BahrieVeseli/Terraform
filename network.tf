resource "aws_vpc" "main_vpc" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = {
    Name        = "master-vpc"
    Environment = "PROD"
    CreatedBy   = "Gentrit-Erza-Bahrie"
    Project     = "DCADD_MASTER"
  }
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.main_vpc.id
  tags = { Name = "master-igw" }
}

# 3 Subnete Publike
resource "aws_subnet" "public_a" {
  vpc_id                  = aws_vpc.main_vpc.id
  cidr_block              = "10.0.1.0/24"
  availability_zone       = "eu-central-1a"
  map_public_ip_on_launch = true
  tags = { Name = "public-a" }
}
resource "aws_subnet" "public_b" {
  vpc_id                  = aws_vpc.main_vpc.id
  cidr_block              = "10.0.2.0/24"
  availability_zone       = "eu-central-1b"
  map_public_ip_on_launch = true
  tags = { Name = "public-b" }
}
resource "aws_subnet" "public_c" {
  vpc_id                  = aws_vpc.main_vpc.id
  cidr_block              = "10.0.3.0/24"
  availability_zone       = "eu-central-1c"
  map_public_ip_on_launch = true
  tags = { Name = "public-c" }
}

# 3 Subnete Private
resource "aws_subnet" "private_a" {
  vpc_id            = aws_vpc.main_vpc.id
  cidr_block        = "10.0.11.0/24"
  availability_zone = "eu-central-1a"
  tags = { Name = "private-a" }
}
resource "aws_subnet" "private_b" {
  vpc_id            = aws_vpc.main_vpc.id
  cidr_block        = "10.0.12.0/24"
  availability_zone = "eu-central-1b"
  tags = { Name = "private-b" }
}
resource "aws_subnet" "private_c" {
  vpc_id            = aws_vpc.main_vpc.id
  cidr_block        = "10.0.13.0/24"
  availability_zone = "eu-central-1c"
  tags = { Name = "private-c" }
}

# NAT Gateway
resource "aws_eip" "nat_eip" {
  domain = "vpc"
}
resource "aws_nat_gateway" "nat_gw" {
  allocation_id = aws_eip.nat_eip.id
  subnet_id     = aws_subnet.public_a.id
  tags = { Name = "master-natgw" }
}

# Route Tables
resource "aws_route_table" "rt_public" {
  vpc_id = aws_vpc.main_vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }
  tags = { Name = "master-rt-public" }
}

resource "aws_route_table" "rt_private" {
  vpc_id = aws_vpc.main_vpc.id
  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat_gw.id
  }
  tags = { Name = "master-rt-private" }
}

# Route Table Associations
resource "aws_route_table_association" "pub_a" { subnet_id = aws_subnet.public_a.id; route_table_id = aws_route_table.rt_public.id }
resource "aws_route_table_association" "pub_b" { subnet_id = aws_subnet.public_b.id; route_table_id = aws_route_table.rt_public.id }
resource "aws_route_table_association" "pub_c" { subnet_id = aws_subnet.public_c.id; route_table_id = aws_route_table.rt_public.id }

resource "aws_route_table_association" "priv_a" { subnet_id = aws_subnet.private_a.id; route_table_id = aws_route_table.rt_private.id }
resource "aws_route_table_association" "priv_b" { subnet_id = aws_subnet.private_b.id; route_table_id = aws_route_table.rt_private.id }
resource "aws_route_table_association" "priv_c" { subnet_id = aws_subnet.private_c.id; route_table_id = aws_route_table.rt_private.id }
