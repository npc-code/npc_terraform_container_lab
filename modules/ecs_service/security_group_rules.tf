#security_group_rules
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

resource "aws_security_group_rule" "alb_https" {
  count = var.lb_enabled ? 1 : 0
  type              = "ingress"
  from_port         = "443"
  to_port           = "443"
  protocol          = "tcp"
  cidr_blocks       = [var.external_ip]
  security_group_id = aws_security_group.alb_sg[0].id
}

resource "aws_security_group_rule" "alb_http" {
  count = var.lb_enabled ? 1 : 0
  type              = "ingress"
  from_port         = "80"
  to_port           = "80"
  protocol          = "tcp"
  cidr_blocks       = [var.external_ip]
  security_group_id = aws_security_group.alb_sg[0].id
}

#not needed?
resource "aws_security_group_rule" "ecs_to_ecs" {
  security_group_id        = aws_security_group.ecs_sg.id
  from_port                = var.container_port
  to_port                  = var.container_port
  protocol                 = "tcp"
  type                     = "ingress"
  source_security_group_id = aws_security_group.ecs_sg.id
}