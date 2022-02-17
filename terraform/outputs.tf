output "vpc_id" {
  description = "The ID of the VPC"
  value       = module.vpc.vpc_id
}


output "load_balancer_dns" {
  description = "Access point to the service in ecs"
  value       = aws_lb.jing_alb.dns_name
}