// VPC
resource "aws_vpc" "vpc" {
  cidr_block = local.cidr
  assign_generated_ipv6_cidr_block = true

  tags = {
    Name        = "VPC (${local.client}-${local.environment})"
    Client      = local.client
    Project     = local.project
    Environment = local.environment
    CreatedBy   = local.createdby
  }
}

// Internet Gateway
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.vpc.id

  tags = {
    Name        = "IGW (${local.client}-${local.environment})"
    Client      = local.client
    Project     = local.project
    Environment = local.environment
    CreatedBy   = local.createdby
  }
}

// Subnets
resource "aws_subnet" "net1" {
  vpc_id                          = aws_vpc.vpc.id
  cidr_block                      = cidrsubnet(local.cidr, 4, 0)
  ipv6_cidr_block                 = cidrsubnet(aws_vpc.vpc.ipv6_cidr_block, 8, 0)
  map_public_ip_on_launch         = true
  assign_ipv6_address_on_creation = true
  availability_zone               = "${local.aws_region}a"

  tags = {
    Name        = "Subnet 1 (${local.client}-${local.environment})"
    Client      = local.client
    Project     = local.project
    Environment = local.environment
    CreatedBy   = local.createdby
  }
  lifecycle {
    // prevent_destroy prevents unintended deletes.
    // Terraform will not destroy these resources without physically changing this line in the code to false.
    prevent_destroy = true
  }
}

resource "aws_subnet" "net2" {
  vpc_id                          = aws_vpc.vpc.id
  cidr_block                      = cidrsubnet(local.cidr, 4, 1)
  ipv6_cidr_block                 = cidrsubnet(aws_vpc.vpc.ipv6_cidr_block, 8, 1)
  map_public_ip_on_launch         = true
  assign_ipv6_address_on_creation = true
  availability_zone               = "${local.aws_region}b"

  tags = {
    Name        = "Subnet 2 (${local.client}-${local.environment})"
    Client      = local.client
    Project     = local.project
    Environment = local.environment
    CreatedBy   = local.createdby
  }
  lifecycle {
    // prevent_destroy prevents unintended deletes.
    // Terraform will not destroy these resources without physically changing this line in the code to false.
    prevent_destroy = true
  }
}

// Route Table
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.vpc.id
  tags = {
    Name        = "Public Route Table (${local.client}-${local.environment})"
    Client      = local.client
    Project     = local.project
    Environment = local.environment
    CreatedBy   = local.createdby
  }
}

resource "aws_route" "public_r1" {
  route_table_id         = aws_route_table.public.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.igw.id
}

resource "aws_route" "public_r2" {
  route_table_id              = aws_route_table.public.id
  destination_ipv6_cidr_block = "::/0"
  gateway_id                  = aws_internet_gateway.igw.id
}

// Route Table Associations
resource "aws_route_table_association" "net1" {
  subnet_id      = aws_subnet.net1.id
  route_table_id = aws_route_table.public.id
}

resource "aws_route_table_association" "net2" {
  subnet_id      = aws_subnet.net2.id
  route_table_id = aws_route_table.public.id
}

