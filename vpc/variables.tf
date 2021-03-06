variable "owner" {
  description = "Insert the Owner for Project"
}

variable "project" {
  description = "Insert the Name of Project"
}

variable "vpc_cidr_blocks" {
    description = "Insert CIR Blocks for VPCs"
}

variable "aws_azs" {
  description = "Run the EC2 Instances in these Availability Zones"
  type        = "list"
}

variable "public_subnets_cidr_blocks" {
    description = "Insert CIR Blocks for VPCs"
    type = "list"
}

variable "private_subnets_cidr_blocks" {
    description = "Insert CIR Blocks for VPCs"
    type = "list"
}
