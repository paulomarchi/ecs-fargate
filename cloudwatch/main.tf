resource "aws_cloudwatch_log_group" "log-group-poc-app" {
  name = "poc-app"
  
  tags {
    Owner = "${var.owner}"
    Project= "${var.project}"
  }
}
