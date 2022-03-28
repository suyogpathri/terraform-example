data "aws_vpc" "vpc" {
    id = var.vpc_id
}

# Create a default security group for VPC
resource "aws_security_group" "default" {
    name = "${var.name}-default-sg"
    description = "The default security group to allow inbound and outbound traffic from the ${var.name}-VPC"
    vpc_id = "${var.vpc_id}"
    
    depends_on = [
        data.aws_vpc.vpc
    ]

    ingress {
        from_port = 0
        to_port = 0
        protocol = "-1"
        self = true
    }

    egress {
        from_port = 0
        to_port = 0
        protocol = "-1"
        self = true
    }

    tags = {
        Environment = var.environment
        Name = "${var.name}-default-sg"
    }
}

# Create a security group for Application Load Balancer.
resource "aws_security_group" "alb" {
    name = "${var.name}-alb-sg"
    description = "The security gorup for the ${var.name}-alb"
    vpc_id = "${var.vpc_id}"

    ingress {
        from_port = var.https_port
        to_port = var.https_port
        protocol = "tcp"
        cidr_blocks = ["${var.alb_cidr}"]
    }

    ingress {
        from_port = var.http_port
        to_port = var.http_port
        protocol = "tcp"
        cidr_blocks = ["${var.alb_cidr}"]
    }

    egress {
        from_port = 0
        to_port = 0
        protocol = "-1"
        cidr_blocks = ["${var.alb_cidr}"]
    }

    tags = {
      Name = "${var.name}-alb-sg"
      Environment = var.environment
    }
}

# Create a security group for the ECS Fargate Service.
resource "aws_security_group" "ecs_fargate" {
    name   = "${var.name}-fatgate-sg"
    vpc_id = var.vpc_id

    ingress {
        protocol         = "tcp"
        from_port        = var.container_port
        to_port          = var.container_port

        security_groups = [aws_security_group.alb.id]
    }

    egress {
        protocol = "-1"
        from_port = 0
        to_port = 0
        cidr_blocks = ["0.0.0.0/0"]
    }

    tags = {
        Name = "${var.name}-fargate-sg"
        Environment = var.environment
    }
}

# Create a security group for the PostgreSQL Database.
resource "aws_security_group" "pcdb" {
    name = "${var.name}-rds-sg"

    description = "The security group is created for RDS postgres servers"
    vpc_id = var.vpc_id

    # Only postgres in
    ingress {
        from_port = 5432
        to_port = 5432
        protocol = "tcp"
        security_groups = [aws_security_group.ecs_fargate.id]
    }

    # Allow all outbound traffic.
    egress {
        from_port = 0
        to_port = 0
        protocol = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }
    
    tags = {
        Name = "${var.name}-rds-sg"
        Environment = var.environment
    }
}