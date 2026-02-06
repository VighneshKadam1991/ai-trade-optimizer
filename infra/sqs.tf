resource "aws_sqs_queue" "orderbook_updates" {
  name = "orderbook-updates"
}
