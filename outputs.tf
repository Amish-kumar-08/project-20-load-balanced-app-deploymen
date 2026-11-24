
output "load_balancer_dns" {
  value = aws_lb.app_alb.dns_name
}

output "ec2_instance_ids" {
  value = aws_instance.web[*].id
}

output "target_group_arn" {
  value = aws_lb_target_group.web_tg.arn
}

