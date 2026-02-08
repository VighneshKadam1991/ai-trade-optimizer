########################################################
# CloudWatch Log Groups
########################################################
resource "aws_cloudwatch_log_group" "market_data" {
  name              = "/ecs/market-data"
  retention_in_days = 7
}

resource "aws_cloudwatch_log_group" "order_book" {
  name              = "/ecs/order-book"
  retention_in_days = 7
}

resource "aws_cloudwatch_log_group" "router" {
  name              = "/ecs/order-router"
  retention_in_days = 7
}

resource "aws_cloudwatch_log_group" "risk" {
  name              = "/ecs/risk-engine"
  retention_in_days = 7
}

resource "aws_cloudwatch_log_group" "execution" {
  name              = "/ecs/execution-engine"
  retention_in_days = 7
}

resource "aws_cloudwatch_log_group" "trade_store" {
  name              = "/ecs/trade-store"
  retention_in_days = 7
}
