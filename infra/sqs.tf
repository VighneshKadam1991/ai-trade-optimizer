resource "aws_sqs_queue" "orderbook_updates" {
  name = "orderbook-updates"
}

resource "aws_sqs_queue" "execution_requests" {
  name = "execution-requests"
}

resource "aws_sqs_queue" "execution_fills" {
  name = "execution-fills"
}

resource "aws_sqs_queue" "risk_requests" {
  name = "risk-requests"
}

resource "aws_sqs_queue" "execution_requests_approved" {
  name = "execution-requests-approved"
}
