output "arn" {
  value = "${aws_alb_target_group.lb_main.arn}"
}

output "name" {
  value = "${aws_alb_target_group.lb_main.name}"
}

output "dns" {
  value = ["${aws_alb.lb_main.dns_name}"]
}
