provider "aws" {
  profile = var.profile
  region  = var.region
  alias   = "main-account"
}

#could specifiy values via variable, to allow for x86 or arm64
data "aws_ami" "ecs_ami" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["amzn2-ami-ecs-hvm-*-x86_64-ebs"]
  }
  provider = aws.main-account
}

module "network" {
  source            = "./network"
  az_count          = var.az_count
  base_network      = var.base_network
  network_mask      = var.network_mask
  subnet_mask       = var.subnet_mask
  nat_gw_production = true

  providers = {
    aws = aws.main-account
  }
}

module "ecs_cluster" {
  source           = "./ecs_cluster"
  cluster_name     = "${var.cluster_name}-${var.environment}"
  environment      = var.environment
  min_cluster_size = var.min_cluster_size
  max_cluster_size = var.max_cluster_size
  image_id = data.aws_ami.ecs_ami.id
  instance_type = var.instance_type
  cluster_subnets_private = module.network.private_subnets

  providers = {
    aws = aws.main-account
  }
}

module "ecs_task_1" {
  source = "./ecs_task"
  task_name = "task_1"
  container_port = 80
  host_port = 80
  container_name = "web_1"
  image_name = "nginx:latest"
  environment = var.environment

  providers = {
    aws = aws.main-account
  }
}