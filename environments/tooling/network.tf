resource "aws_vpc" "tooling_vpc" {
  cidr_block       = var.vpc_cidr
  enable_dns_support = true
  enable_dns_hostnames = true

  tags = {
    Name = "${var.project_name}-tooling-vpc"
  }
}

resource "aws_subnet" "tooling_public_subnet" {
  count = length(var.public_subnet_cidrs)
  vpc_id     = aws_vpc.tooling_vpc.id
  cidr_block = var.public_subnet_cidrs[count.index]
  availability_zone = var.availability_zones[count.index]
  map_public_ip_on_launch = true
  tags = {
    Name = "${var.project_name}-tooling-subnet-${count.index + 1}"
  }
}

resource "aws_internet_gateway" "tooling_igw" {
  vpc_id = aws_vpc.tooling_vpc.id

  tags = {
    Name = "${var.project_name}-tooling-igw"
  }
}

resource "aws_route_table" "tooling_public_rt" {
  vpc_id = aws_vpc.tooling_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.tooling_igw.id
  }

  tags = {
    Name = "${var.project_name}-tooling-public-rt"
  }
}

resource "aws_route_table_association" "tooling_public_rta" {
  count = length(var.public_subnet_cidrs)
  subnet_id      = aws_subnet.tooling_public_subnet[count.index].id
  route_table_id = aws_route_table.tooling_public_rt.id
}

