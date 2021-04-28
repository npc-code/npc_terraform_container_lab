output "vpc_id" {
  value = module.network.vpc_id
}

output "public_subnets" {
  value = module.network.public_subnets
}

output "private_subnets" {
  value = module.network.private_subnets
}

output "ecs_frontend_securitygroup" {
  value = module.ecs_service_1.ecs_security_group_id
}

output "ecs_backend_securitygroup" {
  value = module.ecs_service_mysql.ecs_security_group_id
}