variable "name" {
    type = string
    description = "The name of the stack"
}

variable "environment" {
    type = string
    description = "The environment of the stack"
}

variable "availability_zones" {
    type = list(string)
    description = "The availability zones to use"
}

variable "vpc_id" {
    type = string
    description = "The VPC id to use"
}

variable "public_subnets" {
    type = list(string)
    description = "The value of the public subnet ids"
}

variable "security_group_id" {
    type = string
    description = "The ALB security group id"
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

variable "health_check_path" {
    type = string
    description = "The health check path"
    default = "/"
}

variable "tls_cert_arn" {
  description = "The ARN of the certificate that the ALB uses for https"
}

variable "delete_protection" {
    type = bool
    description = "Whether or not to delete the load balancer"
    default = true 
}

variable "internal" {
    type = bool
    description = "Whether or not to create an internal ALB"
    default = false
}
  
variable "enable_https2" {
    type = bool
    description = "Whether or not to enable HTTP/2"
    default = false
}

variable "target_group_protocol" {
    type = string
    description = "The ABL target group protocol"
}

variable "target_group_type" {
    type = string
    description = "The target group type IP/Instance"
}