resource "aws_ecr_repository" "market_data" {
  name = "market-data-ingestion"
}

resource "aws_ecr_repository" "order_book" {
  name = "order-book-state"
}
