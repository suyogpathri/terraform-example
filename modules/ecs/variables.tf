variable "name" {
    type = string
    description = "The name of the stack"
}

variable "environment" {
    type = string
    description = "The environment of the stack"
}

variable "vpc_id" {
    type = string
    description = "The VPC id to use"
}

variable "private_subnets" {
    type = list(string)
    description = "The value of the private subnet ids"
}

variable "ecr_repository_name" {
    type = string
    description = "The name of ECR repository"
}

variable "iam_role_arn" {
    type = string
    description = "The IAM role arn"
}

variable "container_cpu" {
    type = number
    description = "The number of cpu units used by the task."
    default = 512
}
  
variable "container_memory" {
    type = number
    description = "The amount (in MiB) of memory used by the task."
    default = 1024
}