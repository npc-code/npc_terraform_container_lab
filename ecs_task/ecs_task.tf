resource "aws_ecs_task_definition" "service" {
  family = var.task_name
  network_mode = var.network_mode
  


  container_definitions = jsonencode([
    {
      name      = var.container_name
      image     = var.image_name
      cpu       = 10
      memory    = 512
      essential = true
      portMappings = [
        {
          containerPort = var.container_port
          hostPort      = var.host_port
        }
      ]
    }
  ])
  
  dynamic "volume" {
    for_each = var.v_enabled ? [1] : []
    content {
      name      = var.v_name
      host_path = "/ecs/${var.v_path}"
    }
  }

  
}