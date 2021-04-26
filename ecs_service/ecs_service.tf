resource "aws_ecs_service" "generic_service" {
  name            = var.service_name
  cluster         = var.cluster_id
  task_definition = var.task_definition_arn
  desired_count   = var.desired_count
  iam_role        = aws_iam_role.ecs_role.arn
  depends_on      = [aws_iam_role_policy.ecs_service_role_policy]

  ordered_placement_strategy {
    type  = "binpack"
    field = "cpu"
  }

  dynamic "load_balancer" {
    for_each  = var.lb_enabled ? [1] : []
    content {
      target_group_arn = var.target_group_arn
      container_name = var.container_name
      container_port = var.container_port
    }
  }

}