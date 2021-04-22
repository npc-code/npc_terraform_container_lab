provider "aws" {
  profile = var.profile
  region  = var.region
  alias   = "main-account"
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

  providers = {
    aws = aws.main-account
  }
}