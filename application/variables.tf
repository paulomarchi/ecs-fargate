variable "project" {
  description = "Insert project name"
}

variable "execution_role_arn" {
  description = "Insert iam execution role"
}

variable "cluster_id" {
  description = "ECS Cluster ID"
}

variable "public_subnets_ids" {
  type        = "list"
  description = "VPC Public Subnets"
}

variable "security_groups_app" {
  type        = "list"
  description = "Security Group App"
}

variable "target_group_arn" {
  description = "Insert load balancer target group arn"
}
