variable "base_cidr" {
  type    = string
  default = "10.0.0.0/16"
}

variable "base_network" {
    type = string
    default = "10.0.0.0"
}

variable "network_mask" {
    type = number
    default = 16
}

variable "subnet_mask" {
    type = number
    default = 24
}

variable "az_count" {
    type = number
    default = 0
    description = "number of azs to use.  if not set, all azs will be used for this deployment."
}

variable "nat_gw_production" {
    type = bool
    default = true
    description = "set to true to follow best practice and deploy a nat gateway in every az for use by the private subnet.  false will create only one."   
}

variable "min_cluster_size" {
    type = number
    default = 1
    description = "minimum cluster size for the autoscaling group"
}

variable "max_cluster_size" {
    type = number
    default = 1
    description = "maximum cluster size for the autoscaling group"
}