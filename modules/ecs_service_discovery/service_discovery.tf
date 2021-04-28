resource "aws_service_discovery_private_dns_namespace" "private_namespace" {
  name        = var.namespace_name
  description = var.description
  vpc         = var.vpc_id
}

resource "aws_service_discovery_service" "discovery_service" {
  name = var.service_name

  dns_config {
    namespace_id = aws_service_discovery_private_dns_namespace.private_namespace.id

    dns_records {
      ttl  = 10
      type = "A"
    }

    routing_policy = "MULTIVALUE"
  }

  health_check_custom_config {
    failure_threshold = 1
  }
}