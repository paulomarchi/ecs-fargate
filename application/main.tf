resource "aws_ecs_task_definition" "poc-app" {
  family                   = "${var.project}"
  container_definitions    = "${file("${path.module}/task_definitions/app.json")}"
  network_mode             = "awsvpc"
  cpu                      = "256"
  memory                   = "512"
  requires_compatibilities = ["FARGATE"]
  execution_role_arn       = "${var.execution_role_arn}"
}

resource "aws_ecs_service" "service-poc-app" {
  name            = "${var.project}"
  cluster         = "${var.cluster_id}"
  task_definition = "${aws_ecs_task_definition.poc-app.arn}"
  desired_count   = 2
  launch_type     = "FARGATE"

  load_balancer {
    target_group_arn = "${var.target_group_arn}"
    container_name = "poc-app"
    container_port = 80
  }

  network_configuration {
    subnets         = ["${var.public_subnets_ids}"]
    security_groups = ["${var.security_groups_app}"]
  }
}
