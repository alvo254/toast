resource "aws_vpc" "vpc" {
  cidr_block           = var.vpc_cidr_notation
  //Tenancy defines how EC2 instances are distributed across physical hardware and affects pricing
  instance_tenancy     = "default"
  enable_dns_hostnames = true

  tags = {
    Name = "${var.project}-${var.environment}-vpc"
  }
}

data "aws_region" "current" {}

resource "aws_vpc_ipam" "pam" {
  operating_regions {
    region_name = data.aws_region.current.name
  }
}

resource "aws_vpc_ipv6_cidr_block_association" "ipv6" {
  ipv6_ipam_pool_id = aws_vpc_ipam_pool.ipv6.id
  vpc_id = aws_vpc.vpc.id
}


resource "aws_vpc_ipam_pool" "ipv6" {
  address_family = "ipv6"
  ipam_scope_id  = aws_vpc_ipam.pam.public_default_scope_id
  locale         = "us-east-1"
  description    = "public ipv6"

  aws_service    = "ec2"
}

# resource "aws_vpc_ipam_pool_cidr" "ipv6_test_public" {
#   ipam_pool_id = aws_vpc_ipam_pool.ipv6.id
#   cidr         = var.ipv6_cidr
#   cidr_authorization_context {
#     message   = var.message
#     signature = var.signature
#   }
# }

# create internet gateway and attach it to vpc
resource "aws_internet_gateway" "internet_gateway" {
  vpc_id = aws_vpc.vpc.id

  tags = {
    Name = "${var.project}-${var.environment}-igw"
  }
}

# use data source to get all avalablility zones in region
data "aws_availability_zones" "available_zones" {}

# create public subnet az1
resource "aws_subnet" "public_subnet_az1" {
  vpc_id                  = aws_vpc.vpc.id
  cidr_block              = var.public_subnet
  availability_zone       = data.aws_availability_zones.available_zones.names[0]  //this is indexing
  //resources launched with this will have a public ip address
  map_public_ip_on_launch = true

  tags = {
    Name = "${var.project}-${var.environment}-public-az1"
  }
}

# create public subnet az2
resource "aws_subnet" "public_subnet_az2" {
  vpc_id                  = aws_vpc.vpc.id
  cidr_block              = var.public_subet_2
  availability_zone       = data.aws_availability_zones.available_zones.names[1]
  map_public_ip_on_launch = true

  tags = {
    Name = "${var.project}-${var.environment}-public-az2"
  }
}

# create route table and add public route
resource "aws_route_table" "public_route_table" {
  vpc_id = aws_vpc.vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.internet_gateway.id
  }

  tags = {
    Name = "${var.project}-${var.environment}-public-rt"
  }
}

# associate public subnet az1 "public route table"
resource "aws_route_table_association" "public_subnet_az1_rt_association" {
  subnet_id      = aws_subnet.public_subnet_az1.id
  route_table_id = aws_route_table.public_route_table.id
}

# associate public subnet az2 to "public route table"
resource "aws_route_table_association" "public_subnet_2_rt_association" {
  subnet_id      = aws_subnet.public_subnet_az2.id
  route_table_id = aws_route_table.public_route_table.id
}

# create private app subnet az1
resource "aws_subnet" "private_app_subnet_az1" {
  vpc_id                  = aws_vpc.vpc.id
  cidr_block              = var.private_subnet
  availability_zone       = data.aws_availability_zones.available_zones.names[0]
  map_public_ip_on_launch = false

  tags = {
    Name = "${var.project}-${var.environment}-private-app-az1"
  }
}

# create private app subnet az2
resource "aws_subnet" "private_app_subnet_az2" {
  vpc_id                  = aws_vpc.vpc.id
  cidr_block              = var.private_subnet_2
  availability_zone       = data.aws_availability_zones.available_zones.names[1]
  map_public_ip_on_launch = false

  tags = {
    Name = "${var.project}-${var.environment}-private-app-az2"
  }
}

# create private data subnet az1
resource "aws_subnet" "private_data_subnet_az1" {
  vpc_id                  = aws_vpc.vpc.id
  cidr_block              = var.private_data
  availability_zone       = data.aws_availability_zones.available_zones.names[0]
  map_public_ip_on_launch = false

  tags = {
    Name = "${var.project}-${var.environment}-private-data-az1"
  }
}

# create private data subnet az2
resource "aws_subnet" "private_data_subnet_az2" {
  vpc_id                  = aws_vpc.vpc.id
  cidr_block              = var.private_data_2
  availability_zone       = data.aws_availability_zones.available_zones.names[1]
  map_public_ip_on_launch = false

  tags = {
    Name = "${var.project}-${var.environment}-private-data-az2"
  }
}