resource "aws_security_group" "sg-poc-app" {
  name        = "poc-app"
  description = "Allow inbound traffic on port 80 from load balancer"
  vpc_id      = "${var.vpc_id}"

  ingress {
    from_port       = 80
    to_port         = 80
    protocol        = "tcp"
    security_groups = ["${var.ingress_security_groups}"]
  }

  egress {
    from_port       = 0
    to_port         = 0
    protocol        = "-1"
    cidr_blocks     = ["0.0.0.0/0"]
  }

  tags {
    Name = "POC App"
    Owner = "${var.owner}"
    Project = "${var.project}"
  }
}
