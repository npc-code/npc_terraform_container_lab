variable "cluster_name" {
  type = string
  description = "name for your ecs cluster"
}

variable "environment" {
  type = string
  description = "environment to deploy into" 
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