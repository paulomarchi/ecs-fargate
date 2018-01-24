resource "aws_alb" "lb_main" {
  name               = "lb-main-${var.project}"
  internal           = false
  load_balancer_type = "application"
  security_groups    = ["${var.security_group_id}"]
  subnets            = ["${var.public_subnets_ids}"]

  tags {
    Name = "lb_main_${var.project}"
    Owner = "${var.owner}"
    Project = "${var.project}"
  }
}

resource "aws_alb_target_group" "lb_main" {
  name        = "lb-main-${var.project}"
  port        = "80"
  protocol    = "HTTP"
  vpc_id      = "${var.vpc_id}"
  target_type = "ip"

  tags {
    Name = "lb_main_${var.project}"
    Owner = "${var.owner}"
    Project = "${var.project}"
  }

  depends_on = [
    "aws_alb.lb_main",  
  ]
}

resource "aws_alb_listener" "lb_main" {
  load_balancer_arn = "${aws_alb.lb_main.arn}"
  port              = "80"
  protocol          = "HTTP"

  default_action {
    target_group_arn = "${aws_alb_target_group.lb_main.arn}"
    type             = "forward"
  }
  
  depends_on = [
    "aws_alb.lb_main",  
    "aws_alb_target_group.lb_main",
  ]
}
