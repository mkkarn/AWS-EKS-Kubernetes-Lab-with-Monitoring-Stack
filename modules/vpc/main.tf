################################################################################
# VPC Module
# Creates VPC with public and private subnets for EKS cluster
################################################################################

locals {
  azs = slice(data.aws_availability_zones.available.names, 0, var.az_count)

  tags = merge(
    var.tags,
    {
      "kubernetes.io/cluster/${var.cluster_name}" = "shared"
    }
  )
}

data "aws_availability_zones" "available" {
  state = "available"

  filter {
    name   = "opt-in-status"
    values = ["opt-in-not-required"]
  }
}

################################################################################
# VPC
################################################################################

resource "aws_vpc" "this" {
  cidr_block           = var.vpc_cidr
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = merge(
    local.tags,
    {
      Name = "${var.cluster_name}-vpc"
    }
  )
}

################################################################################
# Internet Gateway
################################################################################

resource "aws_internet_gateway" "this" {
  vpc_id = aws_vpc.this.id

  tags = merge(
    local.tags,
    {
      Name = "${var.cluster_name}-igw"
    }
  )
}

################################################################################
# Public Subnets
################################################################################

resource "aws_subnet" "public" {
  count = length(local.azs)

  vpc_id                  = aws_vpc.this.id
  cidr_block              = cidrsubnet(var.vpc_cidr, 4, count.index)
  availability_zone       = local.azs[count.index]
  map_public_ip_on_launch = true

  tags = merge(
    local.tags,
    {
      Name                                        = "${var.cluster_name}-public-${local.azs[count.index]}"
      "kubernetes.io/role/elb"                    = "1"
      "kubernetes.io/cluster/${var.cluster_name}" = "shared"
    }
  )
}

################################################################################
# Private Subnets
################################################################################

resource "aws_subnet" "private" {
  count = length(local.azs)

  vpc_id            = aws_vpc.this.id
  cidr_block        = cidrsubnet(var.vpc_cidr, 4, count.index + length(local.azs))
  availability_zone = local.azs[count.index]

  tags = merge(
    local.tags,
    {
      Name                                          = "${var.cluster_name}-private-${local.azs[count.index]}"
      "kubernetes.io/role/internal-elb"             = "1"
      "kubernetes.io/cluster/${var.cluster_name}"   = "shared"
    }
  )
}

################################################################################
# NAT Gateway
################################################################################

resource "aws_eip" "nat" {
  count  = var.single_nat_gateway ? 1 : length(local.azs)
  domain = "vpc"

  tags = merge(
    local.tags,
    {
      Name = "${var.cluster_name}-nat-eip-${count.index + 1}"
    }
  )

  depends_on = [aws_internet_gateway.this]
}

resource "aws_nat_gateway" "this" {
  count = var.single_nat_gateway ? 1 : length(local.azs)

  allocation_id = aws_eip.nat[count.index].id
  subnet_id     = aws_subnet.public[count.index].id

  tags = merge(
    local.tags,
    {
      Name = "${var.cluster_name}-nat-${count.index + 1}"
    }
  )

  depends_on = [aws_internet_gateway.this]
}

################################################################################
# Route Tables
################################################################################

# Public Route Table
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.this.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.this.id
  }

  tags = merge(
    local.tags,
    {
      Name = "${var.cluster_name}-public-rt"
    }
  )
}

resource "aws_route_table_association" "public" {
  count = length(local.azs)

  subnet_id      = aws_subnet.public[count.index].id
  route_table_id = aws_route_table.public.id
}

# Private Route Tables
resource "aws_route_table" "private" {
  count = var.single_nat_gateway ? 1 : length(local.azs)

  vpc_id = aws_vpc.this.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.this[count.index].id
  }

  tags = merge(
    local.tags,
    {
      Name = "${var.cluster_name}-private-rt-${count.index + 1}"
    }
  )
}

resource "aws_route_table_association" "private" {
  count = length(local.azs)

  subnet_id      = aws_subnet.private[count.index].id
  route_table_id = aws_route_table.private[var.single_nat_gateway ? 0 : count.index].id
}
