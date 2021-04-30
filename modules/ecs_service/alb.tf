resource "aws_alb" "app_alb" {
  count = var.lb_enabled ? 1 : 0
  name            = "${var.service_name}-alb"
  subnets         = var.alb_public_subnets
  security_groups = [aws_security_group.alb_sg[0].id]
  drop_invalid_header_fields = true
  
  access_logs {
    bucket  = aws_s3_bucket.app_alb_logs[0].bucket
    prefix  = "${var.service_name}-alb"
    enabled = true
  }

  tags = {
    Name        = "${var.service_name}-alb"
    Environment = var.environment
  }
}

resource "aws_s3_bucket" "app_alb_logs" {
  count = var.lb_enabled ? 1 : 0
  bucket_prefix = "${var.service_name}-alb-logs-"
  acl           = "log-delivery-write"
  server_side_encryption_configuration {
  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}


  force_destroy = true
}


resource "aws_alb_target_group" "target_group" {
  count = var.lb_enabled ? 1 : 0
  name_prefix = substr(var.service_name, 0, 6)
  port        = var.container_port
  protocol    = "HTTP"
  vpc_id      = var.vpc_id
  target_type = "ip"

  lifecycle {
    create_before_destroy = true
  }

  health_check {
    path = var.health_check_path
    port = var.container_port
    timeout = 29
  }

  depends_on = [aws_alb.app_alb]
}

resource "aws_alb_listener" "http_forward" {
  count = var.lb_enabled ? 1 : 0
  load_balancer_arn = aws_alb.app_alb[0].arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    target_group_arn = aws_alb_target_group.target_group[0].arn
    type             = "forward"
  }


}

#resource "aws_alb_listener" "http_forward" {
#  load_balancer_arn = aws_alb.app_alb.arn
#  port              = "80"
#  protocol          = "HTTP"

#  default_action {
#    type = "redirect"

#    redirect {
#      port        = "443"
#      protocol    = "HTTPS"
#      status_code = "HTTP_301"
#    }
#  }
#}

#resource "aws_alb_listener" "web_app_https" {
#  load_balancer_arn = aws_alb.app_alb.arn
#  port              = "443"
#  protocol          = "HTTPS"
#  certificate_arn = aws_acm_certificate.cert_request.arn
#  ssl_policy = "ELBSecurityPolicy-2016-08"
#  depends_on        = [aws_alb_target_group.api_target_group]

#  lifecycle {
#    create_before_destroy = true
#  }

#  default_action {
#    target_group_arn = aws_alb_target_group.api_target_group.arn
#    type             = "forward"
#  }
#}