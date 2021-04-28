# ALB Security Group
resource "aws_security_group" "alb_sg" {
  count = var.lb_enabled ? 1 : 0
  name        = "${var.service_name}-alb-sg"
  description = "ALB Security Group"
  vpc_id      = var.vpc_id

  ingress {
    from_port   = "80"
    to_port     = "80"
    protocol    = "tcp"
    cidr_blocks = [var.external_ip]
  }

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

resource "aws_security_group_rule" "https" {
  count = var.lb_enabled ? 1 : 0
  type              = "ingress"
  from_port         = "443"
  to_port           = "443"
  protocol          = "tcp"
  cidr_blocks       = [var.external_ip]
  security_group_id = aws_security_group.alb_sg[0].id
}

resource "aws_security_group_rule" "alb_to_ecs" {
  count = var.lb_enabled ? 1 : 0
  security_group_id        = aws_security_group.alb_sg[0].id
  from_port                = var.container_port
  to_port                  = var.container_port
  protocol                 = "tcp"
  type                     = "egress"
  source_security_group_id = aws_security_group.ecs_sg.id
}

resource "aws_security_group_rule" "alb_to_ecs_ingress" {
  count = var.lb_enabled ? 1 : 0
  security_group_id = aws_security_group.ecs_sg.id
  from_port = var.container_port
  to_port = var.container_port
  protocol = "tcp"
  type = "ingress"
  source_security_group_id = aws_security_group.alb_sg[0].id

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

resource "aws_security_group_rule" "ecs_to_ecs" {
  security_group_id        = aws_security_group.ecs_sg.id
  from_port                = var.container_port
  to_port                  = var.container_port
  protocol                 = "tcp"
  type                     = "ingress"
  source_security_group_id = aws_security_group.ecs_sg.id
}

#would be nice to add ports and security groups dynamically

