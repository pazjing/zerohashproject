resource "aws_lb" "jing_alb" {
  name            = "Jing-load-balancer"
  subnets         = module.vpc.public_subnets
  security_groups = [aws_security_group.alb_sg.id]

  tags = {
    Environment = var.environment
  }
}

resource "aws_lb_target_group" "alb_tg" {
  name        = "Jing-target-group"
  port        = 80
  protocol    = "HTTP"
  vpc_id      = module.vpc.vpc_id
  target_type = "ip"

  tags = {
    Environment = var.environment
  }
}

resource "aws_lb_listener" "alb_listener" {
  load_balancer_arn = aws_lb.jing_alb.id
  port              = "80"
  protocol          = "HTTP"

  default_action {
    target_group_arn = aws_lb_target_group.alb_tg.id
    type             = "forward"
  }

  tags = {
    Environment = var.environment
  }
}

