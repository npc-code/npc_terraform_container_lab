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
  source = "https://github.com/npc-code/aws_modular_vpc?ref=v1.0.1"
  az_count          = 2
  base_network      = "10.0.0.0"
  network_mask      = 16
  subnet_mask       = 24
  nat_gw_production = false
}

module "ecs_cluster" {
  source = "https://github.com/npc-code/aws_ecs_cluster?ref=v1.0.1"
  cluster_name            = "${var.cluster_name}-${var.environment}"
  environment             = test
  min_cluster_size        = 1
  max_cluster_size        = 2
  image_id                = data.aws_ami.ecs_ami.id
  instance_type           = "t3.micro"
  cluster_subnets_private = module.network.private_subnets
  vpc_id                  = module.network.vpc_id
  key_name                = "test"
  external_ip             = "127.0.0.1"
}