resource "aws_ecr_repository" "market_data" {
  name = "market-data-ingestion"
  force_delete = true
}

resource "aws_ecr_repository" "order_book" {
  name = "order-book-state"
  force_delete = true
}

resource "aws_ecr_repository" "order_router" {
  name         = "order-router"
  force_delete = true
}

resource "aws_ecr_repository" "execution_engine" {
  name         = "execution-engine"
  force_delete = true
}

resource "aws_ecr_repository" "trade_store" {
  name         = "trade-store"
  force_delete = true
}

resource "aws_ecr_repository" "risk_engine" {
  name         = "risk-engine"
  force_delete = true
}
