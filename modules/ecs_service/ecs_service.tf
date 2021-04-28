locals {
  use_service_registry = var.service_registry_arn != "" ? true : false
}

resource "aws_ecs_service" "generic_service" {
  name            = var.service_name
  cluster         = var.cluster_id
  task_definition = var.task_definition_arn
  desired_count   = var.desired_count

  ordered_placement_strategy {
    type  = "binpack"
    field = "cpu"
  }

  network_configuration {
    security_groups  = [aws_security_group.ecs_sg.id]
    subnets = var.container_subnets
  }

  dynamic "load_balancer" {
    for_each  = var.lb_enabled ? [1] : []
    content {
      target_group_arn = aws_alb_target_group.target_group[0].arn
      container_name = var.container_name
      container_port = var.container_port
    }
  }

  dynamic "service_registries" {
    for_each = local.use_service_registry ? [1] : []
    content {
      registry_arn = var.service_registry_arn
    }
  }

}