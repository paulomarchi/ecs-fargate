output "cluster_id" {
  value = "${aws_ecs_cluster.fargate.id}"
}

output "cluster_arn" {
  value = "${aws_ecs_cluster.fargate.arn}"
}
