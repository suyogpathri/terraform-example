variable "name" {
    type = string
    description = "The name of the stack"
}

variable "environment" {
    type = string
    description = "The environment of the stack"
}

variable "vpc_cidr" {
    type = string
    description = "The VPC CIDR block"
}

variable "availability_zones" {
    type = list(string)
    description = "The availability zones to use"
}

variable "public_subnet_cidr" {
    type = list(string)
    description = "value of the public subnet CIDR block"
}

variable "private_subnet_cidr" {
    type = list(string)
    description = "value of the private subnet CIDR block"
}

variable "database_subnet_cidr" {
    type = list(string)
    description = "value of the database subnet CIDR block"
}