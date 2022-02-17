provider "aws" {
  region = var.region
}


#####################################################
# VPC Module
#####################################################

module "vpc" {
  source = "terraform-aws-modules/vpc/aws"

  name = "Jing-App-Infra"
  cidr = var.vpc_cidr_block

  azs             = ["${var.region}a", "${var.region}b", "${var.region}c"]
  private_subnets = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
  public_subnets  = var.public_subnet_cidr_blocks

  enable_nat_gateway = true
  single_nat_gateway = true

  tags = {
    Environment = var.environment
  }
}

resource "aws_security_group" "alb_sg" {
  name        = "Jing-alb-SG"
  description = "Allow public web request access traffic"
  vpc_id      = module.vpc.vpc_id

  ingress {
    from_port   = 80
    to_port     = 80
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
    Environment = var.environment
  }
}

resource "aws_security_group" "ecs_task_sg" {
  name   = "Jing-ECS-Task-SG"
  vpc_id = module.vpc.vpc_id

  ingress {
    from_port       = 3000
    to_port         = 3000
    protocol        = "TCP"
    security_groups = [aws_security_group.alb_sg.id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Environment = var.environment
  }
}