output "ecs_service_arn" {
  value = aws_ecs_service.generic_service.id
}