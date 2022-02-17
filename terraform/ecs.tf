
resource "aws_ecs_cluster" "jing_cluster" {
  name = "Jing-Cluster"

  tags = {
    Environment = var.environment
  }
}

resource "aws_ecs_cluster_capacity_providers" "jing_cap_provider" {
  cluster_name = aws_ecs_cluster.jing_cluster.name

  capacity_providers = ["FARGATE"]
}

resource "aws_ecs_task_definition" "nodejs_app" {
  family                   = "nodejs-app"
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = 1024
  memory                   = 2048

  container_definitions = <<DEFINITION
[
  {
    "image": "${var.image_name}",
    "cpu": 1024,
    "memory": 2048,
    "name": "nodejs-app",
    "networkMode": "awsvpc",
    "portMappings": [
      {
        "containerPort": 3000,
        "hostPort": 3000
      }
    ]
  }
]
DEFINITION

  tags = {
    Environment = var.environment
  }
}

resource "aws_ecs_service" "nodejs_app_service" {
  name            = "nodejs-app-service"
  cluster         = aws_ecs_cluster.jing_cluster.id
  task_definition = aws_ecs_task_definition.nodejs_app.arn
  desired_count   = 2
  launch_type     = "FARGATE"

  network_configuration {
    security_groups  = [aws_security_group.ecs_task_sg.id]
    subnets          = module.vpc.private_subnets
    assign_public_ip = false
  }

  load_balancer {
    target_group_arn = aws_lb_target_group.alb_tg.id
    container_name   = "nodejs-app"
    container_port   = 3000
  }

  depends_on = [aws_lb_listener.alb_listener]

  tags = {
    Environment = var.environment
  }
}
