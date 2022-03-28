# Create a ECS Fargate Cluster
resource "aws_ecs_cluster" "ecs" {
    name = var.name
    capacity_providers = ["FARGATE"]


    setting {
        name = "containerInsights"
        value = "enabled"
    }
    tags = {
        Name = var.name
        Environment = var.environment
    }
}

data "aws_ecr_repository" "ecr_repository" {
    name = var.ecr_repository_name
}

# Create a new task definition for the ECS Cluster
resource "aws_ecs_task_definition" "service" {
    network_mode = "awsvpc"
    requires_compatibilities = "FARGATE"
    cpu = "${var.container_cpu}"
    memory = "${var.container_memory}"
    execution_role_arn = var.iam_role_arn
    task_role_arn = var.iam_role_arn
}