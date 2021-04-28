# ALB Security Group
resource "aws_security_group" "alb_sg" {
  count = var.lb_enabled ? 1 : 0
  name        = "${var.service_name}-alb-sg"
  description = "ALB Security Group"
  vpc_id      = var.vpc_id

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  
  tags = {
    Name = "${var.service_name}-alb-sg"
  }
}

# ECS Cluster Security Group
resource "aws_security_group" "ecs_sg" {
  vpc_id      = var.vpc_id
  name        = "${var.service_name}-ecs-service-sg"
  description = "Allow egress from container"

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name        = "${var.service_name}-ecs-service-sg"
    Environment = var.service_name
  }
}


