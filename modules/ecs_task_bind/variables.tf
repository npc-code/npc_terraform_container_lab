variable "container_name" {
	type = string
	description = "container name"
}

variable "container_path" {
  type = string
  description = "path on container you want to map the volume to.  defaults to empty if you are not using a volume"
  default = ""
}

variable "container_port" {
  type = number
  description = "port that the container exposes"
}

variable "cpu" {
  type = number
  description = "desired cpu usage"
}

variable "memory" {
  type = number
  description = "desired memory usage"
}

variable "environment" {
  type = string
  description = "environment that task will run in"
}

variable "image_name" {
  type = string
  description = "container image to use"
}

variable "host_port" {
  type = number
  description = "port exposed on the host"
}

variable "region" {
  type = string
  description = "region container is running in.  used for log stream"
}

variable "task_name" {
  type = string
  description = "name for this task"
}

variable "use_volume" {
  type = bool
  description = "set to true to use a volume"
  default = false
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

variable "environment_variables" {
  type        = list
  description = "ecs task environment variables. list of {'name': 'value', 'value' : 'value'} items.  see default for example"
  default = [{ "name": "test", "value": "what"}, {"name": "test2", "value": "okay"}]
}