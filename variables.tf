variable "profile" {
  type    = string
  default = "npc_personal_admin"
}

variable "region" {
  type    = string
  default = "us-east-1"
}

variable "base_network" {
  type        = string
  default     = "10.0.0.0"
  description = "base network to use for vpc"

}

variable "network_mask" {
  type        = number
  default     = 16
  description = "network mask to use.  ex: default value will result in 10.0.0.0/16"
}

variable "subnet_mask" {
  type        = number
  default     = 24
  description = "subnet mask to use.  ex: default value will result in 10.0.1.0/24"
}

variable "az_count" {
  type        = number
  default     = 0
  description = "number of azs to use. if left at zero, all available azs will be used in the target region."
}

variable "nat_gw_production" {
  type        = bool
  default     = true
  description = "set to true to follow best practice and deploy a nat gateway in every az for use by the private subnet.  false will create only one."

}

variable "cluster_name" {
  type        = string
  description = "name for the ecs cluster"
}

variable "min_cluster_size" {
  type        = number
  description = "minimum cluster size for ec2 autoscaling group"
}

variable "max_cluster_size" {
  description = "maximum cluster size for ec2 autoscaling group"

}

variable "environment" {
  type        = string
  description = "environment to deploy to"
}
