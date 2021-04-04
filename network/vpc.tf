locals {
    base_cidr = "${var.base_network}/${var.network_mask}"
    new_bits = var.subnet_mask - var.network_mask
    num_subnets = var.az_count == 0 ? length(data.aws_availability_zones.azs.names) : var.az_count
    num_nats = var.nat_gw_production ? local.num_subnets : 1
}

resource "aws_vpc" "main_vpc" {
  assign_generated_ipv6_cidr_block = false
  cidr_block                       = local.base_cidr
  enable_dns_hostnames             = true
  enable_dns_support               = true
  instance_tenancy                 = "default"
  tags = {
    "Name" = "main_vpc"
  }
}

data "aws_availability_zones" "azs" {
  state = "available"
}

resource "aws_subnet" "public_subnets" {
    count = local.num_subnets
    vpc_id = aws_vpc.main_vpc.id
    cidr_block = cidrsubnet(local.base_cidr, local.new_bits, count.index + 1)
    availability_zone = element(data.aws_availability_zones.azs.names, count.index)
    map_public_ip_on_launch = true
    tags = {
        "Name" = "public-subnet-${count.index}"
    }
}

resource "aws_subnet" "private_subnets" {
    count = local.num_subnets
    vpc_id = aws_vpc.main_vpc.id
    cidr_block = cidrsubnet(local.base_cidr, local.new_bits, count.index + local.num_subnets + 1)
    availability_zone = element(data.aws_availability_zones.azs.names, count.index)
    tags = {
        "Name" = "private-subnet-${count.index}"
    }
}