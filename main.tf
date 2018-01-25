module "vpc" {
  source              = "./vpc"
  owner               = "${var.owner}"
  project             = "${var.project}"
  vpc_cidr_blocks     = "${var.vpc_cidr_blocks}"
  aws_azs             = ["${var.aws_azs}"]
  public_subnets_cidr_blocks = ["${var.public_subnets_cidr_blocks}"]
  private_subnets_cidr_blocks = ["${var.private_subnets_cidr_blocks}"]  
}

module "cluster" {
  source = "./cluster"
  project = "${var.project}"
}

module "security-group-lb" {
  source = "./security-group-lb"
  project = "${var.project}"
  owner = "${var.owner}"
  vpc_id = "${module.vpc.vpc_id}"
}

module "security-group-app" {
  source = "./security-group-app"
  project = "${var.project}"
  owner = "${var.owner}"
  vpc_id = "${module.vpc.vpc_id}"
  ingress_security_groups = "${module.security-group-lb.security_group_id}"
}

module "load-balancer" {
  source = "./load-balancer"
  project = "${var.project}"
  owner = "${var.owner}"
  vpc_id = "${module.vpc.vpc_id}"
  security_group_id = "${module.security-group-lb.security_group_id}"
  public_subnets_ids = ["${module.vpc.public_subnets_ids}"]
}

module "iam" {
  source = "./iam"
}

module "cloudwatch" {
  source = "./cloudwatch"
  owner = "${var.owner}"
  project = "${var.project}"
}

module "application" {
  source = "./application"
  project = "${var.project}"
  execution_role_arn = "${module.iam.execution_role_arn}"
  cluster_id = "${module.cluster.cluster_id}"
  private_subnets_ids  = ["${module.vpc.private_subnets_ids}"]
  security_groups_app = "${module.security-group-app.security_group_id}"
  target_group_arn = "${module.load-balancer.arn}"
  role_arn = "${module.iam.execution_role_arn}"
}
