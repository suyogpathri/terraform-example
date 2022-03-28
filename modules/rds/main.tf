# Create a Random password for RDS database
resource "random_password" "master_password" {
    length  = 12
    special = true
    lower = true
    upper = true
    number = true
}

# Create a new secret for the RDS database
resource "aws_secretsmanager_secret" "rds_credentials" {
    name = "${var.name}-rds-master-user-credentials"
    description = "${var.name}-db master user credentials."
}

resource "aws_db_instance" "postgres_db" {
    allocated_storage = var.storage_size
    engine  = var.database_engine
    engine_version = var.engine_verion
    instance_class = var.instance_class
    name = var.database_name
    username = var.user_name
    password = "${random_password.master_password.result}"
    parameter_group_name = var.parameter_group_name
    skip_final_snapshot = var.skip_final_snapshot
    backup_retention_period = var.backup_retention_period
    db_subnet_group_name = "${var.database_subnets}"
    multi_az = false
    port = 5432
    publicly_accessible = false
    storage_encrypted = true # you should always do this
    storage_type = "gp2"

    vpc_security_group_ids   = ["${var.security_group_id}"]
    deletion_protection = false
    allow_major_version_upgrade = false
    auto_minor_version_upgrade = true
    iam_database_authentication_enabled = false
    identifier = "${var.name}-rds-instance"
    copy_tags_to_snapshot = true
    delete_automated_backups = true
    enabled_cloudwatch_logs_exports = "postgresql"
    performance_insights_enabled = true
    performance_insights_retention_period = 7 # Days
    monitoring_interval = 60 # Seconds
    maintenance_window = "Mon:00:00-Mon:03:00"
    backup_window = "09:46-10:16"
    max_allocated_storage = 50

    tags = {
        Name = "${var.name}-rds-instance"
        Environment = "${var.environment}"
        Project = "${var.project}"
        Owner = "${var.owner}"
        Description = "${var.description}"
    }
}

resource "aws_secretsmanager_secret_version" "rds_credentials" {
    secret_id     = aws_secretsmanager_secret.rds_credentials.id
    secret_string = <<EOF
        {
        "username": "${aws_db_instance.default.master_username}",
        "password": "${random_password.master_password.result}",
        "engine": "postgres",
        "host": "${aws_db_instance.default.address}",
        "port": ${aws_db_instance.default.port},
        "dbClusterIdentifier": "${aws_db_instance.default.identifier}"
        }
    EOF

    tags = {
        Name = "${var.name}-rds-instance"
        Environment = "${var.environment}"
    } 
}

