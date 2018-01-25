variable "project" {
  description = "Insert project name"
}

variable "execution_role_arn" {
  description = "Insert iam execution role"
}

variable "cluster_id" {
  description = "ECS Cluster ID"
}

variable "private_subnets_ids" {
  type        = "list"
  description = "VPC Public Subnets"
}

variable "security_groups_app" {
  description = "Security Group App"
}

variable "target_group_arn" {
  description = "Insert load balancer target group arn"
}

variable "role_arn" {
  description = "Insert ecs autoscale role arn"
}
