# Create a new VPC
resource "aws_vpc" "vpc" {
    cidr_block = var.vpc_cidr

    tags = {
        Name = var.name
        Environment = var.environment
    }
}

# Ineternet gateway for the public subnet
resource "aws_internet_gateway" "ig" {
    vpc_id = aws_vpc.vpc.id

    tags = {
        Name = "${var.name}-ig"
        Environment = var.environment
    }
}

# Elastic IP for NAT gateway
resource "aws_eip" "nat_eip" {
    vpc = true
    depends_on = [
        aws_internet_gateway.ig
    ]
    tags = {
        Name = "${var.name}-nat-eip"
        Environment = var.environment
    }
}

# NAT gateway for the private subnets
resource "aws_nat_gateway" "nat" {
    allocation_id = aws_eip.nat_eip.id
    subnet_id = element(aws_subnet.public.*.id, 0)
    depends_on = [
        aws_internet_gateway.ig
    ]
    tags = {
        Name = "${var.name}-nat"
        Environment = var.environment
    }
}

# Public subnet for VPC
resource "aws_subnet" "public" {
    vpc_id = aws_vpc.vpc.id
    count = length(var.public_subnet_cidr)
    cidr_block = element(var.public_subnet_cidr, count.index)
    availability_zone = element(var.availability_zones, count.index)
    map_public_ip_on_launch = true
    tags = {
        Name = "${var.name}-${element(var.availability_zones, count.index)}-public"
        Environment = var.environment
    }
}

# Private subnet for VPC
resource "aws_subnet" "private" {
    vpc_id = aws_vpc.vpc.id
    count = length(var.private_subnet_cidr)
    cidr_block = element(var.private_subnet_cidr, count.index)
    availability_zone = element(var.availability_zones, count.index)
    map_public_ip_on_launch = false
    tags = {
        Name = "${var.name}-${element(var.availability_zones, count.index)}-private"
        Environment = var.environment
    }
}

# Database subnet for VPC
resource "aws_subnet" "database" {
    vpc_id = aws_vpc.vpc.id
    count = length(var.database_subnet_cidr)
    cidr_block = element(var.database_subnet_cidr, count.index)
    availability_zone = element(var.availability_zones, count.index)
    map_public_ip_on_launch = false
    tags = {
        Name = "${var.name}-${element(var.availability_zones, count.index)}-database"
        Environment = var.environment
    }
}

# Private subnet Route table
resource "aws_route_table" "private" {
    vpc_id = aws_vpc.vpc.id
    tags = {
        Name = "${var.name}-private-route-table"
        Environment = var.environment
    }
}

# Database subnet Route table
resource "aws_route_table" "database" {
    vpc_id = aws_vpc.vpc.id
    tags = {
      Name = "${var.name}-database-route-table"
      Environment = var.environment
    }
}

# Public subnet Route table
resource "aws_route_table" "public" {
    vpc_id = aws_vpc.vpc.id
    tags = {
        Name = "${var.name}-public-route-table"
        Environment = var.environment
    }
}

# Add route for public route table to internet gateway
resource "aws_route" "public_internet_gateway" {
    route_table_id = aws_route_table.public.id
    destination_cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.ig.id
}

# Add route for private route table to NAT gateway
resource "aws_route" "private_nat_gateway" {
    route_table_id = aws_route_table.private.id
    destination_cidr_block = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat.id
}

# Add route for database route table to NAT gateway
resource "aws_route" "database_nat_gateway" {
    route_table_id = aws_route_table.database.id
    destination_cidr_block = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat.id
}

# Associate the public route table with the public subnet
resource "aws_route_table_association" "public" {
    subnet_id = element(aws_subnet.public.*.id, count.index)
    route_table_id = aws_route_table.public.id
    count = length(var.public_subnet_cidr)
}
  
# Associate the private route table with the private subnet
resource "aws_route_table_association" "private" {
    subnet_id = element(aws_subnet.private.*.id, count.index)
    route_table_id = aws_route_table.private.id
    count = length(var.private_subnet_cidr)
}

# Associate the database route table tiwht the database subnet
resource "aws_route_table_association" "database" {
    subnet_id = element(aws_subnet.database.*.id, count.index)
    route_table_id = aws_route_table.database.id
    count = length(var.database_subnet_cidr)
}