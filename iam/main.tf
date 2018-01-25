data "aws_iam_policy_document" "poc-app-role" {
  statement {
    actions = [
      "sts:AssumeRole",
    ]

    principals {
      type        = "Service"
      identifiers = ["ecs-tasks.amazonaws.com", "application-autoscaling.amazonaws.com"]
    }
  }
}

data "aws_iam_policy_document" "poc-app" {
  statement {
    actions = [
      "ecr:GetAuthorizationToken",
      "ecr:BatchCheckLayerAvailability",
      "ecr:GetDownloadUrlForLayer",
      "ecr:BatchGetImage",
      "logs:CreateLogStream",
      "logs:PutLogEvents",
    ]

    resources = [
      "*",
    ]
  }
}

resource "aws_iam_role" "iam-role-poc-app" {
  name               = "poc-app"
  assume_role_policy = "${data.aws_iam_policy_document.poc-app-role.json}"
}

resource "aws_iam_policy" "iam-policy-poc-app" {
  name        = "poc-app"
  description = "POC App Policy"
  policy      = "${data.aws_iam_policy_document.poc-app.json}"
}

resource "aws_iam_role_policy_attachment" "iam-role-policy-attach-poc-app" {
  role       = "${aws_iam_role.iam-role-poc-app.name}"
  policy_arn = "${aws_iam_policy.iam-policy-poc-app.arn}"
}
