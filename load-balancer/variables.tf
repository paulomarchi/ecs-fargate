variable "owner" {
  description = "Owner"
}

variable "project" {
  description = "Project Name"
}

variable "vpc_id" {
  type        = "list"
  description = "VPC ID"
}

variable "public_subnets_ids" {
  type        = "list"
  description = "VPC Public Subnets"
}

variable "security_group_ids" {
  type = "list"
  description = "Insert Secutrity Group IDs"
}
