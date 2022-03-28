# Create a new Application Load Balancer.
resource "aws_lb" "alb" {
    name = "${var.name}-alb"
    security_groups = ["${var.security_group_id}"]
    subnets = "${var.public_subnets}"
    internal = var.internal
    enable_http2 = var.enable_https2
    load_balancer_type = "application"

    enable_deletion_protection = var.delete_protection

    tags = {
        Name = "${var.name}-alb"
        Environment = var.environment
    }
}

# Create a target group for alb
resource "aws_lb_target_group" "tg" {
    name = "${var.name}-alb-tg"
    port = var.http_port
    protocol = var.target_group_protocol
    vpc_id = "${var.vpc_id}"
    target_type = var.target_group_type

    health_check {
        path = "${var.health_check_path}"
        port = "${var.http_port}"
        healthy_threshold = "3"
        interval = "30"
        protocol = "HTTP"
        matcher = "200"
        timeout = "3"
        unhealthy_threshold = "2"
    }
}

# Create a HTTP listener to redirect http traffic to https listener
resource "aws_lb_listener" "http" {
    load_balancer_arn = "${aws_lb.alb.arn}"
    port = var.http_port
    protocol = "HTTP"

    default_action {
        type = "redirect"
        redirect {
            port = var.https_port
            protocol = "HTTPS"
            status_code = "HTTP_301"
        }
    }
}

# Create a HTTPS listener for alb and redirect traffic to the target group
resource "aws_lb_listener" "https" {
    load_balancer_arn = "${aws_lb.alb.arn}"
    port = var.https_port
    protocol = "HTTPS"
    ssl_policy = "ELBSecurityPolicy-TLS-1-2-Ext-2018-06"
    certificate_arn   = "${var.tls_cert_arn}"

    default_action {
        target_group_arn = "${aws_lb_target_group.tg.arn}"
        type = "forward"
    }
}

