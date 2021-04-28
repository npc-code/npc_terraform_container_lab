#variables
variable "vpc_id" {
  type = string
  description = "vpc id"
}

variable "namespace_name" {
  type = string
  description = "private domain name to use. EX: neato.example.local"
}

variable "service_name" {
  type = string
  description = "name that will be prepended to namespace_name"
}

variable "description" {
  type = string
  description = "brief description of discovery service endpoint"
}
