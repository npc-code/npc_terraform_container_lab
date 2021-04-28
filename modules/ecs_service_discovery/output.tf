#output
output "service_discovery_arn" {
  value = aws_service_discovery_service.discovery_service.arn
}

output "service_discovery_id" {
  value = aws_service_discovery_service.discovery_service.id
}