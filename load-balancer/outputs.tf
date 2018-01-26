output "lb_listener_arn" {
  value = "${aws_alb_listener.lb_main.arn}"
}

output "arn" {
  value = "${aws_alb_target_group.lb_main.arn}"
}

output "name" {
  value = "${aws_alb_target_group.lb_main.name}"
}

output "dns" {
  value = "${aws_alb.lb_main.dns_name}"
}

output "zone_id" {
  value = "${aws_alb.lb_main.zone_id}"
}
