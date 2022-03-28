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

variable "database_subnets" {
    type = list(string)
    description = "The value of the database subnet ids"
}

variable "security_group_id" {
    type = string
    description = "The RDS security group id"
}

variable "storage_size" {
    type = number
    description = "The RDS database storage size."
}

variable "database_engine" {
    type = string
    description = "The RDS database engine"
}
  
variable "engine_verion" {
    type = string
    description = "The RDS database engine version"
}

variable "instance_class" {
    type = string
    description = "The RDS instance class"
}

variable "database_name" {
    type = string
    description = "The RDS database name"
}

variable "user_name" {
    type = string
    description = "The RDS database user name"
}

variable "parameter_group_name" {
    type = string
    description = "The RDS parameter group name"
}

variable "skip_final_snapshot" {
    type = boolean
    description = "Whether to skip the final snapshot"
}

variable "backup_retention_period" {
    type = number
    description = "The RDS backup retention period"
}
  

