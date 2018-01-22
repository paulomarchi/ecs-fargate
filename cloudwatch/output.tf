output "log_group_arn" {
  value = "${aws_cloudwatch_log_group.log-group-poc-app.arn}"
}
