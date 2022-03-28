output "vpc_id" {
    value = "${aws_vpc.vpc.id}"
    description = "The VPC id."
}

output "public_subnets" {
    value = aws_subnet.public[*].id
    description = "List of IDs of public subnets"
}

output "private_subnets" {
    value = aws_subnet.private[*].id
    description = "List of IDs of private subnets"
}

output "database_subnets"{
    value = aws_subnet.database[*].id
    description = "List of IDs of database subnets"
}