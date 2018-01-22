resource "aws_ecs_cluster" "fargate" {
  name = "${var.project}"
}
