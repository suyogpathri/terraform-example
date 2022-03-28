
variable "name" {
    type = string
    description = "The name of the stack"
}

variable "environment" {
    type = string
    description = "The environment of the stack"
}

variable "http_port" {
    type = number
    description = "The http port to listen on."
    default = 80
}

variable "https_port" {
    type = number
    description = "The https port to listen on."
    default = 443
}

variable "alb_cidr" {
    type = string
    description = "The CIDR block for the ALB"
}

variable "vpc_id" {
    type = string
    description = "The VPC id to use"
}

variable "container_port" {
    type = number
    description = "Ingres and egress port of the container"
}