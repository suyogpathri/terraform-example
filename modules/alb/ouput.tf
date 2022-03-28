output "aws_lb_dns" {
    value = "${aws_lb.alb.dns_name}"
    description = "The application load balancer dns name"
}

output "aws_lb_target_group_arn" {
    value = "${aws_lb_target_group.tg.arn}"
    description = "The target group arn"
}