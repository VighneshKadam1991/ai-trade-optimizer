output "stream_arns" {
  value = { for k, v in aws_kinesis_stream.streams : k => v.arn }
}
output "stream_names" {
  value = { for k, v in aws_kinesis_stream.streams : k => v.name }
}
