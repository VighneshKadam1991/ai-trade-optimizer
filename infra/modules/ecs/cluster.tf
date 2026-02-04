resource "aws_ecs_cluster" "this" {
  name = "agentic-cluster-${var.environment}"
}