output "execution_role_arn" {
  value = "${aws_iam_role.iam-role-poc-app.arn}"
}

output "iam_policy" {
  value = "${aws_iam_policy.iam-policy-poc-app.arn}"
}
