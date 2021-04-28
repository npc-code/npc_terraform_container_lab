locals {
  mount_points = var.use_volume ? [{sourceVolume = "data", containerPath = var.container_path}] : []
}


resource "aws_ecs_task_definition" "generic_task_volumes" {
  family = var.task_name
  network_mode = var.network_mode
  execution_role_arn = aws_iam_role.ecs_execution_role.arn
  task_role_arn      = aws_iam_role.ecs_execution_role.arn
  
  container_definitions = jsonencode([
    {
      name      = var.container_name
      image     = var.image_name
      cpu       = var.cpu
      memory    = var.memory
      essential = true
      portMappings = [
        {
          containerPort = var.container_port
          hostPort      = var.host_port
        }
      ]
      environment = var.environment_variables 
      logConfiguration = {
        logDriver = "awslogs"
         options = {
         awslogs-group = aws_cloudwatch_log_group.container_log_group.name
         awslogs-region = var.region
         awslogs-stream-prefix = var.container_name
        }
      }
      mountPoints = local.mount_points
    }    
  ])

  dynamic "volume" {
    for_each = var.use_volume ? [1] : [0]
    content {
      name = "data"
      host_path = "/ecs/data"
    }
  }
  
}

resource "aws_cloudwatch_log_group" "container_log_group" {
  name = "${var.container_name}-logs"

  tags = {
    Application = var.container_name
  }
}