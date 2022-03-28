output "alb_security_group_id" {
    value = "${aws_security_group.alb.id}"
    description = "The value of alb security group id"
}