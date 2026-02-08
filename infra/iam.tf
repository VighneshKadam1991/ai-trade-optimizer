resource "aws_iam_role" "ecs_task_role" {
  name = "ecs-task-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Effect = "Allow",
      Principal = { Service = "ecs-tasks.amazonaws.com" },
      Action = "sts:AssumeRole"
    }]
  })
}

resource "aws_iam_role_policy" "ecs_policy" {
  role = aws_iam_role.ecs_task_role.id

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Effect = "Allow",
      Action = [
        "sqs:*",
        "logs:*"
      ],
      Resource = "*"
    }]
  })
}

resource "aws_iam_role_policy" "trade_store_policy" {
  name = "trade-store-policy"
  role = aws_iam_role.ecs_task_role.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "dynamodb:PutItem",
          "dynamodb:Scan"
        ]
        Resource = aws_dynamodb_table.trades.arn
      },
      {
        Effect = "Allow"
        Action = [
          "sqs:ReceiveMessage",
          "sqs:DeleteMessage",
          "sqs:GetQueueAttributes"
        ]
        Resource = aws_sqs_queue.execution_fills.arn
      }
    ]
  })
}

resource "aws_iam_role_policy" "risk_engine_policy" {
  name = "risk-engine-policy"
  role = aws_iam_role.ecs_task_role.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "sqs:ReceiveMessage",
          "sqs:DeleteMessage",
          "sqs:SendMessage",
          "sqs:GetQueueAttributes"
        ]
        Resource = [
          aws_sqs_queue.risk_requests.arn,
          aws_sqs_queue.execution_requests_approved.arn
        ]
      }
    ]
  })
}
