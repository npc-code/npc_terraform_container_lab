resource "aws_iam_role_policy" "ecs_service_role_policy" {
  name   = "${var.service_name}_role_policy"
  policy = data.aws_iam_policy_document.ecs_service_policy.json
  role   = aws_iam_role.ecs_role.id
}

resource "aws_iam_role" "ecs_role" {
  name               = "${var.service_name}-ecs_role"
  assume_role_policy = data.aws_iam_policy_document.ecs_service_role.json
}

#may want to use policy_id here
# ECS Service Policy
data "aws_iam_policy_document" "ecs_service_policy" {
  statement {
    effect    = "Allow"
    resources = ["*"]

    actions = [
      "elasticloadbalancing:Describe*",
      "elasticloadbalancing:DeregisterInstancesFromLoadBalancer",
      "elasticloadbalancing:RegisterInstancesWithLoadBalancer",
      "ec2:Describe*",
      "ec2:AuthorizeSecurityGroupIngress",
    ]
  }
}

# ECS Service Policy
data "aws_iam_policy_document" "ecs_service_role" {
  statement {
    effect  = "Allow"
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["ecs.amazonaws.com"]
    }
  }
}

resource "aws_s3_bucket_policy" "alb_logs_policy" {
  count = var.lb_enabled ? 1 : 0
  bucket = aws_s3_bucket.app_alb_logs[0].id
  policy = data.aws_iam_policy_document.s3_bucket_alb_write[0].json
}

data "aws_elb_service_account" "main" {

}


data "aws_iam_policy_document" "s3_bucket_alb_write" {
  count = var.lb_enabled ? 1 : 0
  policy_id = "${var.service_name}_s3_bucket_alb_logs"

  statement {
    actions = [
      "s3:PutObject",
    ]
    effect = "Allow"
    resources = [
      "${aws_s3_bucket.app_alb_logs[0].arn}/*",
    ]

    principals {
      identifiers = ["${data.aws_elb_service_account.main.arn}"]
      type        = "AWS"
    }
  }

  statement {
    actions = [
      "s3:PutObject"
    ]
    effect = "Allow"
    resources = ["${aws_s3_bucket.app_alb_logs[0].arn}/*"]
    principals {
      identifiers = ["delivery.logs.amazonaws.com"]
      type        = "Service"
    }
  }


  statement {
    actions = [
      "s3:GetBucketAcl"
    ]
    effect = "Allow"
    resources = ["${aws_s3_bucket.app_alb_logs[0].arn}"]
    principals {
      identifiers = ["delivery.logs.amazonaws.com"]
      type        = "Service"
    }
  }
}
