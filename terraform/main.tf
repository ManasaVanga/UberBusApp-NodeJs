provider "aws" {
  region = "us-east-1"
}

# Using these data sources allows the configuration to be
# generic for any region.
#data "aws_region" "current" {}

data "aws_availability_zones" "available" {}

resource "aws_vpc" "main" {
  cidr_block = "10.0.0.0/16"

  tags = map(
    "Name", "terraform-ecs-demo",
  )
}

resource "aws_subnet" "demo" {
  count = 2

  availability_zone = data.aws_availability_zones.available.names[count.index]
  cidr_block        = "10.0.${count.index}.0/24"
  vpc_id            = aws_vpc.main.id

  tags = map(
    "Name", "terraform-ecs-demo",
  )
}


resource "aws_internet_gateway" "demo" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "terraform-ecs-demo"
  }
}

resource "aws_route_table" "demo" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.demo.id
  }
}

resource "aws_route_table_association" "demo" {
  count          = 2
  subnet_id      = aws_subnet.demo.*.id[count.index]
  route_table_id = aws_route_table.demo.id
}



resource "aws_lb" "uber-bus-app-ALB-tf" {
  name               = "uber-bus-app-ALB-tf"
  load_balancer_type = "application"
  internal           = false
  subnets            = aws_subnet.demo.*.id
  tags = {
    "env"       = "prod"
    "createdBy" = "aditya"
  }
  security_groups = [aws_security_group.uberbus-app-sec-grp-tf.id]
}

resource "aws_security_group" "uberbus-app-sec-grp-tf" {
  name   = "uberbus-app-sec-grp-tf"
  vpc_id = aws_vpc.main.id
  ingress {
    from_port        = 80
    to_port          = 80
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    "env"       = "prod"
    "createdBy" = "aditya"
  }
}

resource "aws_lb_target_group" "uber-bus-app-target-group-tf" {
  name        = "uber-bus-app-target-group-tf"
  port        = "80"
  protocol    = "HTTP"
  target_type = "ip"
  vpc_id      = aws_vpc.main.id
  health_check {
    path                = "/test"
    healthy_threshold   = 2
    unhealthy_threshold = 10
    timeout             = 60
    interval            = 30
    matcher             = "200"
  }
}

resource "aws_lb_listener" "web-listener" {
  load_balancer_arn = aws_lb.uber-bus-app-ALB-tf.arn
  port              = "80"
  protocol          = "HTTP"
  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.uber-bus-app-target-group-tf.arn
  }
}

resource "aws_lb_listener_rule" "static" {
  listener_arn = aws_lb_listener.web-listener.arn
  priority     = 1

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.uber-bus-app-target-group-tf.arn
  }

  condition {
    path_pattern {
      values = ["/"]
    }
  }

  condition {
    path_pattern {
      values = ["/test"]
    }
  }
}



resource "aws_ecr_repository" "uber_bus_app_be_tf" {
  name                 = "uber_bus_app_be_tf"
  image_tag_mutability = "MUTABLE"

  image_scanning_configuration {
    scan_on_push = true
  }
}

resource "aws_ecs_cluster" "UberBusAppClusterTf" {
  name               = "UberBusAppClusterTf"
  capacity_providers = ["FARGATE"]

}

resource "aws_security_group" "ecs_tasks" {
  name        = "tf-ecs-tasks"
  description = "allow inbound access from the ALB only"
  vpc_id      = "${aws_vpc.main.id}"

  ingress {
    protocol    = "tcp"
    from_port   = 3001
    to_port     = 3001
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    protocol    = "-1"
    from_port   = 0
    to_port     = 0
    cidr_blocks = ["0.0.0.0/0"]
  }
}


resource "aws_ecs_service" "uber-bus-app-be-service-tf" {
  name    = "uber-bus-app-be-service-tf"
  cluster = aws_ecs_cluster.UberBusAppClusterTf.id
  #   task_definition = aws_ecs_task_definition.app.arn
  desired_count = 1
  launch_type   = "FARGATE"

  network_configuration {
    security_groups = [aws_security_group.ecs_tasks.id]
    subnets         = aws_subnet.demo.*.id
  }

  load_balancer {
    target_group_arn = aws_lb_target_group.uber-bus-app-target-group-tf.arn
    container_name   = "uber_bus_app_be_tf"
    container_port   = 3001
  }

  depends_on = [
    "aws_lb_listener.web-listener",
  ]

  lifecycle {
    ignore_changes = [desired_count]
  }

}
