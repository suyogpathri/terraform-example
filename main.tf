# Parameter from Parameter Store for SSL Certificates
data "aws_ssm_parameter" "certificate_arn" {
    name = var.tsl_certificate_ssm
}

# Parameter from Parameter Store for IAM role
data "aws_ssm_parameter" "iam_role_arn" {
    name = "ecs-iam-role-arn-ssm"
}   

# Create a new VPC
module "vpc_uat" {
    source = "./modules/vpc"

    vpc_cidr = "172.26.0.0/25"

    public_subnet_cidr = ["172.26.0.0/28", "172.26.0.16/28"]
    private_subnet_cidr = ["172.26.0.32/28", "172.26.0.48/28"]
    database_subnet_cidr = ["172.26.0.64/28", "172.26.0.80/28"]
    availability_zones = ["us-east-1d", "us-east-1c"]

    name = "${var.name}"
    environment = "${var.environment}"
}

# Create a security groups.
module "security_groups_uat"{
    source = "./modules/security_groups"
    
    alb_cidr = "0.0.0.0/0"
    vpc_id = module.vpc_uat.vpc_id
    http_port =80
    https_port = 443
    container_port = var.container_port

    name = "${var.name}"
    environment = "${var.environment}"
}

# Create a RDS instance
# module "rds_uat" {
#     source = "./modules/rds"

#     name = "${var.name}"
#     environment = "${var.environment}"
# }

# Create a new Application Load Balancer
module "alb_uat" {
    source = "./modules/alb"

    availability_zones = ["us-east-1d", "us-east-1c"]
    vpc_id = module.vpc_uat.vpc_id
    public_subnets = "${module.vpc_uat.public_subnets}"
    tls_cert_arn = "${data.aws_ssm_parameter.certificate_arn.value}"
    security_group_id = "${module.security_groups_uat.alb_security_group_id}"
    http_port =80
    https_port = 443
    delete_protection = var.alb_delete_protection
    internal = var.alb_internal_configuration
    enable_https2 = var.alb_enable_https2
    target_group_protocol = var.alb_target_group_protocol
    target_group_type = var.alb_target_group_type

    name = "${var.name}"
    environment = "${var.environment}"
}

# Create a new ECS Cluster, Definiations, Services and Tasks for application
# module "ecs_uat" {
#     source = "./modules/ecs"

#     vpc_id = module.vpc_uat.vpc_id
#     private_subnets = "${module.vpc_uat.private_subnets}"
    
#     name = "${var.name}"
#     environment = "${var.environment}"
#     ecr_repository_name = "dev-transient-pc-service"
#     iam_role_arn = "${data.aws_ssm_parameter.iam_role_arn.value}"
#     container_cpu = 512
#     container_memory = 1024

# }