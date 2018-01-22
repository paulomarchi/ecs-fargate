output "security_group_ids" {
  value = ["${aws_security_group.sg-load-balancer.*.id}"]
}
