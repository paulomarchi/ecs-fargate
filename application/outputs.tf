output "arn" {
  value = "${aws_ecs_task_definition.poc-app.arn}"
}

output "family" {
  value = "${aws_ecs_task_definition.poc-app.family}"
}

output "revision" {
  value = "${aws_ecs_task_definition.poc-app.revision}"
}
