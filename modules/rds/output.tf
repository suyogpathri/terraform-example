output "address" {
    value = "${aws_db_instance.postgres_db.address}"
    description = "The RDS endpoint address"
}