resource "aws_ecr_repository" "market_data" {
  name = "market-data-ingestion"
  force_delete = true
}

resource "aws_ecr_repository" "order_book" {
  name = "order-book-state"
  force_delete = true
}
