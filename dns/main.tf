data "aws_route53_zone" "selected" {
  name         = "${var.domain}."
  private_zone = false
}

resource "aws_route53_record" "poc-marshals" {
  zone_id = "${data.aws_route53_zone.selected.zone_id}"
  name = "${var.project}.${var.domain}"
  type = "A"

  alias {
    name                   = "${var.lb_dns_name}"
    zone_id                = "${var.lb_zone_id}"
    evaluate_target_health = true
  }
}
