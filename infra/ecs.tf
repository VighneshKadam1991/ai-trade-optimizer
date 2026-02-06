#################################################
# ECS Cluster
#################################################
resource "aws_ecs_cluster" "cluster" {
  name = "quant-execution-cluster"
}

#################################################
# Market Data Task Definition
#################################################
resource "aws_ecs_task_definition" "market_data" {
  family                   = "market-data"
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = 256
  memory                   = 512
  execution_role_arn       = aws_iam_role.ecs_task_role.arn

  container_definitions = jsonencode([{
    name  = "market-data"
    image = "${aws_ecr_repository.market_data.repository_url}:latest"
    essential = true

    environment = [{
      name  = "QUEUE_URL"
      value = aws_sqs_queue.orderbook_updates.id
    }]

    logConfiguration = {
      logDriver = "awslogs"
      options = {
        awslogs-group         = "/ecs/market-data"
        awslogs-region        = "eu-west-2"
        awslogs-stream-prefix = "ecs"
      }
    }
  }])
}

#################################################
# Order Book Task Definition
#################################################
resource "aws_ecs_task_definition" "order_book" {
  family                   = "order-book"
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = 256
  memory                   = 512
  execution_role_arn       = aws_iam_role.ecs_task_role.arn

  container_definitions = jsonencode([{
    name  = "order-book"
    image = "${aws_ecr_repository.order_book.repository_url}:latest"
    essential = true

    environment = [{
      name  = "QUEUE_URL"
      value = aws_sqs_queue.orderbook_updates.id
    }]

    logConfiguration = {
      logDriver = "awslogs"
      options = {
        awslogs-group         = "/ecs/order-book"
        awslogs-region        = "eu-west-2"
        awslogs-stream-prefix = "ecs"
      }
    }
  }])
}

#################################################
# Market Data ECS Service  (MISSING BEFORE)
#################################################
resource "aws_ecs_service" "market_data" {
  name            = "market-data-service"
  cluster         = aws_ecs_cluster.cluster.id
  task_definition = aws_ecs_task_definition.market_data.arn
  desired_count   = 1
  launch_type     = "FARGATE"

  network_configuration {
    subnets         = aws_subnet.public[*].id
    security_groups = [aws_security_group.ecs.id]
    assign_public_ip = true
  }
}

#################################################
# Order Book ECS Service  (MISSING BEFORE)
#################################################
resource "aws_ecs_service" "order_book" {
  name            = "order-book-service"
  cluster         = aws_ecs_cluster.cluster.id
  task_definition = aws_ecs_task_definition.order_book.arn
  desired_count   = 1
  launch_type     = "FARGATE"

  network_configuration {
    subnets         = aws_subnet.public[*].id
    security_groups = [aws_security_group.ecs.id]
    assign_public_ip = true
  }
}
