provider "aws" {
  region = local.region
}

locals {
  region = "ap-southeast-2"
}

################################################################################
# VPC Module
################################################################################

module "vpc" {
  source = "terraform-aws-modules/vpc/aws"

  name = "jing-app-infra"
  cidr = "10.0.0.0/16"

  azs             = ["${local.region}a", "${local.region}b", "${local.region}c"]
  #private_subnets = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
  public_subnets  = ["10.0.101.0/24", "10.0.102.0/24", "10.0.103.0/24"]

  enable_nat_gateway = true
  single_nat_gateway = false 

  tags = {
    User = "jing"
  }
}

resource "aws_security_group" "simple_public_sg" {
  name        = "Public-sg-jing"
  description = "Allow web request access traffic"
  vpc_id      = module.vpc.vpc_id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "TCP"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "TCP"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 3000
    to_port     = 3000
    protocol    = "TCP"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "Public-sg-jing"
    User = "jing"
  }
}

resource "aws_ecs_cluster" "jing-cluster" {
  name = "jing-cluster"
}

resource "aws_ecs_cluster_capacity_providers" "jing-cap-provider" {
  cluster_name = aws_ecs_cluster.jing-cluster.name

  capacity_providers = ["FARGATE"]
}

resource "aws_ecs_task_definition" "zerohash-app" {
  family                   = "zerohash-app"
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = 1024
  memory                   = 2048

  container_definitions = <<DEFINITION
[
  {
    "image": "pazjing/zerohashapp:1.0.0",
    "cpu": 1024,
    "memory": 2048,
    "name": "zerohash-app",
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
}

resource "aws_ecs_service" "zerohash-app" {
  name            = "zerohash-service"
  cluster         = aws_ecs_cluster.jing-cluster.id
  task_definition = aws_ecs_task_definition.zerohash-app.arn
  desired_count   = 1
  launch_type     = "FARGATE"

  network_configuration {
    security_groups  = [aws_security_group.simple_public_sg.id]
    subnets          = module.vpc.public_subnets
    assign_public_ip = true
  }
}
