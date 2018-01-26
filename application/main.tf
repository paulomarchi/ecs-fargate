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
  name            = "poc-app"
  cluster         = "${var.cluster_id}"
  task_definition = "${aws_ecs_task_definition.poc-app.arn}"
  desired_count   = 2
  launch_type     = "FARGATE"

  load_balancer {
    target_group_arn = "${var.target_group_arn}"
    container_name = "poc-app"
    container_port = 3000
  }

  network_configuration {
    subnets         = ["${var.private_subnets_ids}"]
    security_groups = ["${var.security_groups_app}"]
  }

  depends_on = [
    "aws_ecs_task_definition.poc-app",
  ]

}

resource "aws_cloudwatch_metric_alarm" "poc_app_service_high" {
  alarm_name          = "${var.project}-CPU-Utilization-High-30"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = "1"
  metric_name         = "CPUUtilization"
  namespace           = "AWS/ECS"
  period              = "60"
  statistic           = "Average"
  threshold           = "30"

  dimensions {
    ClusterName = "${var.project}"
    ServiceName = "${aws_ecs_service.service-poc-app.name}"
  }

  alarm_actions = ["${aws_appautoscaling_policy.poc_app_up.arn}"]

  depends_on = [
    "aws_ecs_service.service-poc-app",
    "aws_appautoscaling_policy.poc_app_up",
    "aws_ecs_task_definition.poc-app",
    "aws_appautoscaling_target.poc_app_scale_target"
  ]
}

resource "aws_cloudwatch_metric_alarm" "poc_app_service_low" {
  alarm_name          = "${var.project}-CPU-Utilization-Low-5"
  comparison_operator = "LessThanThreshold"
  evaluation_periods  = "1"
  metric_name         = "CPUUtilization"
  namespace           = "AWS/ECS"
  period              = "60"
  statistic           = "Average"
  threshold           = "5"

  dimensions {
    ClusterName = "${var.project}"
    ServiceName = "${aws_ecs_service.service-poc-app.name}"
  }

  alarm_actions = ["${aws_appautoscaling_policy.poc_app_down.arn}"]

  depends_on = [
    "aws_ecs_service.service-poc-app",
    "aws_appautoscaling_policy.poc_app_down",
    "aws_ecs_task_definition.poc-app",
    "aws_appautoscaling_target.poc_app_scale_target"
  ]
}

resource "aws_appautoscaling_target" "poc_app_scale_target" {
  service_namespace = "ecs"
  resource_id = "service/${var.project}/${aws_ecs_service.service-poc-app.name}"
  scalable_dimension = "ecs:service:DesiredCount"
  role_arn = "${var.role_arn}"
  min_capacity = 1
  max_capacity = 4

  depends_on = [
    "aws_ecs_service.service-poc-app",
  ]

}

resource "aws_appautoscaling_policy" "poc_app_up" {
  name                      = "poc-app-scale-up"
  service_namespace         = "ecs"
  resource_id               = "service/${var.project}/${aws_ecs_service.service-poc-app.name}"
  scalable_dimension        = "ecs:service:DesiredCount"

  step_scaling_policy_configuration {
    adjustment_type         = "ChangeInCapacity"
    cooldown                = 300
    metric_aggregation_type = "Average"

    step_adjustment {
      metric_interval_upper_bound = 0
      scaling_adjustment          = -1
    }
  }

  depends_on = [
    "aws_appautoscaling_target.poc_app_scale_target",
    "aws_ecs_service.service-poc-app",
  ]
}

resource "aws_appautoscaling_policy" "poc_app_down" {
  name                      = "poc-app-scale-down"
  service_namespace         = "ecs"
  resource_id               = "service/${var.project}/${aws_ecs_service.service-poc-app.name}"
  scalable_dimension        = "ecs:service:DesiredCount"

  step_scaling_policy_configuration {
    adjustment_type         = "ChangeInCapacity"
    cooldown                = 300
    metric_aggregation_type = "Average"

    step_adjustment {
      metric_interval_upper_bound = 0
      scaling_adjustment          = -1
    }
  }

  depends_on = [
    "aws_appautoscaling_target.poc_app_scale_target",
    "aws_ecs_service.service-poc-app",
  ]
}
