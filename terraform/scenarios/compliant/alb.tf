  resource "aws_lb" "web_lb" {
    name               = "web-lb"
    internal           = false
    load_balancer_type = "application"
    security_groups    = [aws_security_group.alb_security_group.id]
    subnets            = [aws_subnet.dmz_subnet1.id, aws_subnet.dmz_subnet2.id]

    tags = {
      Name        = "WebLB"
      Owner       = "Andrew"
      "Managed by" = "Terraform"
    }
  }

resource "aws_lb_target_group" "web_tg" {
  name     = "web-tg"
  port     = 80
  protocol = "HTTP"
  vpc_id   = aws_vpc.my_vpc.id
  
  health_check {
    path                = "/"
    interval            = 30
    timeout             = 5
    healthy_threshold  = 2
    unhealthy_threshold = 2
  }
   tags = {
    Name        = "WebTG"
    Owner       = "Andrew"
    "Managed by" = "Terraform"
  }
}

resource "aws_lb_target_group_attachment" "web_tg_attachment1" {
  target_group_arn = aws_lb_target_group.web_tg.arn
  target_id        = aws_instance.web_server1.id
  port             = 80
}

resource "aws_lb_target_group_attachment" "web_tg_attachment2" {
  target_group_arn = aws_lb_target_group.web_tg.arn
  target_id        = aws_instance.web_server2.id
  port             = 80
}

resource "aws_lb_listener" "web_listener" {
  load_balancer_arn = aws_lb.web_lb.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.web_tg.arn
  }
  
}