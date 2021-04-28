output "ecs_service_arn" {
  value = aws_ecs_service.generic_service.id
}

output "ecs_security_group_id" {
  value = aws_security_group.ecs_sg.id
}
