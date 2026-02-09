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
  task_role_arn            = aws_iam_role.ecs_task_role.arn

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
  task_role_arn            = aws_iam_role.ecs_task_role.arn
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

resource "aws_ecs_task_definition" "order_router" {
  family                   = "order-router"
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu    = 256
  memory = 512
  execution_role_arn = aws_iam_role.ecs_task_role.arn

  container_definitions = jsonencode([{
    name  = "order-router"
    image = "${aws_ecr_repository.order_router.repository_url}:latest"
    essential = true

    environment = [{
      name  = "EXECUTION_QUEUE"
      value = aws_sqs_queue.execution_requests.id
    }]
  }])
}

resource "aws_ecs_task_definition" "execution_engine" {
  family                   = "execution-engine"
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu    = 256
  memory = 512
  execution_role_arn = aws_iam_role.ecs_task_role.arn

  container_definitions = jsonencode([{
    name  = "execution-engine"
    image = "${aws_ecr_repository.execution_engine.repository_url}:latest"
    essential = true

    environment = [
      {
        name  = "EXECUTION_REQUEST_QUEUE"
        value = aws_sqs_queue.execution_requests.id
      },
      {
        name  = "EXECUTION_FILL_QUEUE"
        value = aws_sqs_queue.execution_fills.id
      }
    ]
  }])
}

resource "aws_ecs_task_definition" "trade_store" {
  family                   = "trade-store"
  requires_compatibilities = ["FARGATE"]
  network_mode             = "awsvpc"
  cpu    = 256
  memory = 512
  execution_role_arn = aws_iam_role.ecs_task_role.arn

  container_definitions = jsonencode([{
    name  = "trade-store"
    image = "${aws_ecr_repository.trade_store.repository_url}:latest"
    essential = true

    environment = [
      {
        name  = "FILL_QUEUE"
        value = aws_sqs_queue.execution_fills.id
      },
      {
        name  = "TRADES_TABLE"
        value = aws_dynamodb_table.trades.name
      }
    ]
  }])
}

resource "aws_ecs_task_definition" "risk_engine" {
  family                   = "risk-engine"
  requires_compatibilities = ["FARGATE"]
  network_mode             = "awsvpc"
  cpu    = 256
  memory = 512
  execution_role_arn = aws_iam_role.ecs_task_role.arn

  container_definitions = jsonencode([{
    name  = "risk-engine"
    image = "${aws_ecr_repository.risk_engine.repository_url}:latest"
    essential = true

    environment = [
      {
        name  = "RISK_REQUEST_QUEUE"
        value = aws_sqs_queue.risk_requests.id
      },
      {
        name  = "APPROVED_QUEUE"
        value = aws_sqs_queue.execution_requests_approved.id
      }
    ]
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
    subnets         = [aws_subnet.public.id]
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
    subnets         = [aws_subnet.public.id]
    security_groups = [aws_security_group.ecs.id]
    assign_public_ip = true
  }
}

resource "aws_ecs_service" "order_router" {
  name            = "order-router-service"
  cluster         = aws_ecs_cluster.cluster.id
  task_definition = aws_ecs_task_definition.order_router.arn
  desired_count   = 1
  launch_type     = "FARGATE"

  network_configuration {
    subnets         = [aws_subnet.public.id]
    security_groups = [aws_security_group.ecs.id]
    assign_public_ip = true
  }
}

resource "aws_ecs_service" "execution_engine" {
  name            = "execution-engine-service"
  cluster         = aws_ecs_cluster.cluster.id
  task_definition = aws_ecs_task_definition.execution_engine.arn
  desired_count   = 1
  launch_type     = "FARGATE"

  network_configuration {
    subnets         = [aws_subnet.public.id]
    security_groups = [aws_security_group.ecs.id]
    assign_public_ip = true
  }
}

resource "aws_ecs_service" "trade_store" {
  name            = "trade-store-service"
  cluster         = aws_ecs_cluster.cluster.id
  task_definition = aws_ecs_task_definition.trade_store.arn
  desired_count   = 1
  launch_type     = "FARGATE"

  network_configuration {
    subnets         = [aws_subnet.public.id]
    security_groups = [aws_security_group.ecs.id]
    assign_public_ip = true
  }
}

resource "aws_ecs_service" "risk_engine" {
  name            = "risk-engine-service"
  cluster         = aws_ecs_cluster.cluster.id
  task_definition = aws_ecs_task_definition.risk_engine.arn
  desired_count   = 1
  launch_type     = "FARGATE"

  network_configuration {
    subnets         = [aws_subnet.public.id]
    security_groups = [aws_security_group.ecs.id]
    assign_public_ip = true
  }
}
