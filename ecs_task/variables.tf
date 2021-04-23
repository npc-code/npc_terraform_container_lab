variable "container_name" {
	type = string
	description = "container name"
}

variable "environment" {
  type = string
  description = "environment that task will run in"
}

variable "image_name" {
  type = string
  description = "container image to use"
}

variable "container_port" {
  type = number
  description = "port that the container exposes"
}

variable "host_port" {
  type = number
  description = "port exposed on the host"
}

variable "task_name" {
  type = string
  description = "name for this task"
}

variable "v_enabled" {
  type = bool
  default = false
  description = "set to true to use a volume"
}

variable "v_name" {
  type = string
  default = ""
  description = "volume name to use if volume is needed"
}

variable "v_path" {
  type = string
  default = ""
  description = "path to volume on host"
}

variable "network_mode" {
  type = string
  default = "awsvpc"
  description = "network mode to use"
}