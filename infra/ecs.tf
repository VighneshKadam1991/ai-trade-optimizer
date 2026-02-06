resource "aws_ecs_cluster" "cluster" {
  name = "quant-execution-cluster"
}

resource "aws_ecs_task_definition" "market_data" {
  family                   = "market-data"
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = 256
  memory                   = 512
  execution_role_arn       = aws_iam_role.ecs_task_role.arn

  container_definitions = jsonencode([{
    name  = "market-data"
    image = aws_ecr_repository.market_data.repository_url
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
