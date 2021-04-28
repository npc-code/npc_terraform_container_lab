variable "az_count" {
  type        = number
  default     = 0
  description = "number of azs to use. if left at zero, all available azs will be used in the target region."
}

variable "base_network" {
  type        = string
  default     = "10.0.0.0"
  description = "base network to use for vpc"
}

variable "cluster_name" {
  type        = string
  description = "name for the ecs cluster"
}

variable "environment" {
  type        = string
  description = "environment to deploy to"
}

variable "environment_variables" {
  type        = list(any)
  description = "ecs task environment variables. list of {'name': 'value', 'value' : 'value'} items.  see default for example"
  default     = [{ "name" : "test", "value" : "what" }, { "name" : "test2", "value" : "okay" }]
}

variable "external_ip" {
  type        = string
  description = "external ip in cidr to allow access"
  default     = "0.0.0.0/0"
}

variable "instance_type" {
  type        = string
  description = "instance type to use for the cluster"
}

variable "key_name" {
  type        = string
  description = "aws key to use for instance debugging"
}

variable "max_cluster_size" {
  description = "maximum cluster size for ec2 autoscaling group"
}

variable "min_cluster_size" {
  type        = number
  description = "minimum cluster size for ec2 autoscaling group"
}

variable "nat_gw_production" {
  type        = bool
  default     = true
  description = "set to true to follow best practice and deploy a nat gateway in every az for use by the private subnet.  false will create only one."
}

variable "network_mask" {
  type        = number
  default     = 16
  description = "network mask to use.  ex: default value will result in 10.0.0.0/16"
}

variable "profile" {
  type    = string
  default = "npc_personal_admin"
}

variable "region" {
  type    = string
  default = "us-east-1"
}

variable "subnet_mask" {
  type        = number
  default     = 24
  description = "subnet mask to use.  ex: default value will result in 10.0.1.0/24"
}



