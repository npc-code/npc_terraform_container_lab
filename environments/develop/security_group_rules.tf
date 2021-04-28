resource "aws_security_group_rule" "frontend_to_backend" {
  security_group_id        = module.ecs_service_mysql.ecs_security_group_id
  from_port                = 3306
  to_port                  = 3306
  protocol                 = "tcp"
  type                     = "ingress"
  source_security_group_id = module.ecs_service_1.ecs_security_group_id
}