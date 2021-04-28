provider "aws" {
  profile = var.profile
  region  = var.region
}

#could specifiy values via variable, to allow for x86 or arm64
data "aws_ami" "ecs_ami" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["amzn2-ami-ecs-hvm-*-x86_64-ebs"]
  }
}

module "network" {
  source = "github.com/npc-code/aws_modular_vpc?ref=v1.0.0"
  az_count          = var.az_count
  base_network      = var.base_network
  network_mask      = var.network_mask
  subnet_mask       = var.subnet_mask
  nat_gw_production = false
}

module "ecs_cluster" {
  source = "github.com/npc-code/aws_ecs_cluster?ref=v1.0.0"
  cluster_name            = "${var.cluster_name}-${var.environment}"
  environment             = var.environment
  min_cluster_size        = var.min_cluster_size
  max_cluster_size        = var.max_cluster_size
  image_id                = data.aws_ami.ecs_ami.id
  instance_type           = var.instance_type
  cluster_subnets_private = module.network.private_subnets
  vpc_id                  = module.network.vpc_id
  key_name                = var.key_name
  external_ip             = var.external_ip
}

module "ecs_service_1" {
  source              = "../../modules/ecs_service"
  task_definition_arn = module.ecs_task_1.task_arn
  desired_count       = 2
  service_name        = "web-service"
  cluster_id          = module.ecs_cluster.ecs_cluster_id
  container_subnets   = module.network.private_subnets
  alb_public_subnets  = module.network.public_subnets
  vpc_id              = module.network.vpc_id
  environment         = var.environment
  container_port      = 8080
  container_name      = "adminer"
  lb_enabled          = true
  external_ip         = var.external_ip
}

module "ecs_service_mysql" {
  source              = "../../modules/ecs_service"
  task_definition_arn = module.ecs_task_volumes.task_arn
  desired_count       = 2
  service_name        = "mysql-test-service"
  cluster_id          = module.ecs_cluster.ecs_cluster_id
  container_subnets   = module.network.private_subnets
  #alb_public_subnets = module.network.public_subnets
  vpc_id               = module.network.vpc_id
  environment          = var.environment
  container_port       = 3306
  container_name       = "mysql"
  lb_enabled           = false
  service_registry_arn = module.ecs_service_discovery_mysql.service_discovery_arn
}

module "ecs_service_discovery_mysql" {
  source         = "../../modules/ecs_service_discovery"
  vpc_id         = module.network.vpc_id
  namespace_name = "mysql.container.local"
  service_name   = "toy"
  description    = "toy discovery for mysql containers"
}

module "ecs_task_1" {
  source                = "../../modules/ecs_task"
  task_name             = "task_1"
  container_port        = 8080
  host_port             = 8080
  container_name        = "adminer"
  image_name            = "adminer:latest"
  environment           = var.environment
  region                = var.region
  memory                = 512
  cpu                   = 10
  environment_variables = [{ "name" : "ADMINER_DEFAULT_SERVER", "value" : "toy.mysql.container.local" }]
}

module "ecs_task_volumes" {
  source                = "../../modules/ecs_task_volumes"
  task_name             = "task_volumes"
  container_port        = 3306
  host_port             = 3306
  container_name        = "mysql"
  image_name            = "mysql:latest"
  environment           = var.environment
  region                = var.region
  memory                = 512
  cpu                   = 10
  environment_variables = var.environment_variables
}

resource "aws_security_group_rule" "frontend_to_backend" {
  security_group_id        = module.ecs_service_mysql.ecs_security_group_id
  from_port                = 3306
  to_port                  = 3306
  protocol                 = "tcp"
  type                     = "ingress"
  source_security_group_id = module.ecs_service_1.ecs_security_group_id
}