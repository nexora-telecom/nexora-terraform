resource "aws_vpc" "this" {
  cidr_block           = var.vpc_cidr
  enable_dns_support   = true
  enable_dns_hostnames = true
  tags                 = { Name = "${var.project_name}-${var.environment}-vpc" }
}

resource "aws_internet_gateway" "this" {
  vpc_id = aws_vpc.this.id
  tags   = { Name = "${var.project_name}-${var.environment}-igw" }
}

resource "aws_subnet" "public" {
  count                   = length(var.public_subnet_cidrs)
  vpc_id                  = aws_vpc.this.id
  cidr_block              = var.public_subnet_cidrs[count.index]
  availability_zone       = var.availability_zones[count.index]
  map_public_ip_on_launch = true
  tags                    = { Name = "${var.project_name}-${var.environment}-public-subnet-${count.index + 1}" }
}

resource "aws_subnet" "compute" {
  count                   = length(var.compute_subnet_cidrs)
  vpc_id                  = aws_vpc.this.id
  cidr_block              = var.compute_subnet_cidrs[count.index]
  availability_zone       = var.availability_zones[count.index]
  map_public_ip_on_launch = false
  tags                    = { Name = "${var.project_name}-${var.environment}-compute-subnet-${count.index + 1}" }
}

resource "aws_subnet" "data" {
  count                   = length(var.data_subnet_cidrs)
  vpc_id                  = aws_vpc.this.id
  cidr_block              = var.data_subnet_cidrs[count.index]
  availability_zone       = var.availability_zones[count.index]
  map_public_ip_on_launch = false
  tags                    = { Name = "${var.project_name}-${var.environment}-data-subnet-${count.index + 1}" }
}

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.this.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.this.id
  }

  tags = { Name = "${var.project_name}-${var.environment}-public-rt" }
}

resource "aws_route_table_association" "public" {
  count          = length(var.public_subnet_cidrs)
  subnet_id      = aws_subnet.public[count.index].id
  route_table_id = aws_route_table.public.id
}

resource "aws_route_table" "compute" {
  vpc_id = aws_vpc.this.id

  tags = { Name = "${var.project_name}-${var.environment}-compute-rt" }
}

resource "aws_route_table_association" "compute" {
  count          = length(var.compute_subnet_cidrs)
  subnet_id      = aws_subnet.compute[count.index].id
  route_table_id = aws_route_table.compute.id
}

resource "aws_route_table" "data" {
  vpc_id = aws_vpc.this.id

  tags = { Name = "${var.project_name}-${var.environment}-data-rt" }
}

resource "aws_route_table_association" "data" {
  count          = length(var.data_subnet_cidrs)
  subnet_id      = aws_subnet.data[count.index].id
  route_table_id = aws_route_table.data.id
}