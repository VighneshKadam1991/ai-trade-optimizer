resource "aws_kinesis_stream" "streams" {
  for_each = var.streams

  name             = "${var.project_name}-${var.environment}-${each.key}"
  shard_count      = each.value.shard_count
  retention_period = each.value.retention_period

  shard_level_metrics = [
    "IncomingBytes",
    "IncomingRecords",
    "OutgoingBytes",
    "OutgoingRecords",
  ]

  stream_mode_details {
    stream_mode = "PROVISIONED"
  }

  tags = {
    Name        = "${var.project_name}-${var.environment}-${each.key}"
    Environment = var.environment
  }
}
