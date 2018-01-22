variable "owner" {
  description = "Owner"
}

variable "project" {
  description = "Project Name"
}

variable "vpc_id" {
  description = "VPC ID"
  type        = "list"
}

variable "ingress_security_groups" {
  type        = "list"
  description = "Ingress Security Groups"
}
