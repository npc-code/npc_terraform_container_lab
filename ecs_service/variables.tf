variable "alb_public_subnets" {
  type = list
  description = "public subnets for the load balancer to use"
  default = []
}

variable "lb_enabled" {
	type = bool
	description = "set to true to use a load_balancer"
	default = false
}

variable "target_group_arn" {
  type = string
  description = "target group arn to use with alb"
  default = ""
}

variable "container_name" {
  type = string
  description = "container name for use with alb"
  default = ""
}

variable "container_port" {
  type = number
  description = "container port for use with alb"
  default = 0
}

variable "external_ip" {
  type = string
  description = "external ip with cidr notation to allow access"
  default = "0.0.0.0/0"
}

variable "service_name" {
  type = string
  description = "name of the service"
}

variable "cluster_id" {
  type = string
  description = "ecs cluster id to place service into"
}

variable "task_definition_arn" {
  type = string
  description = "task definition arn used to place task within service"
}

variable "desired_count" {
  type = number
  description = "number of tasks to run"
}

variable "environment" {
  type = string
  description = "environment to deploy into"
}

variable "security_group_ids" {
  type = list
  description = "security group ids to use"
  default = []
}

variable "container_subnets" {
  type = list
  description = "subnets to place the containers into."
}

variable "health_check_path" {
  type = string
  description = "path for health check"
  default = "/"
}

variable "vpc_id" {
  type = string
  description = "vpc to place load balancer into"
}
