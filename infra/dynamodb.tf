resource "aws_dynamodb_table" "trades" {
  name         = "trades"
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "trade_id"

  attribute {
    name = "trade_id"
    type = "S"
  }
}
