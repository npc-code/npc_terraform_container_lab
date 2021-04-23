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

variable "service_name" {
  type = string
  decription = "name of the service"
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