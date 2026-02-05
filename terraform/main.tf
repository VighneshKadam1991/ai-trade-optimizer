module "networking" {
  source = "./modules/networking"
}

module "ecr" {
  source = "./modules/ecr"
}

module "ecs_cluster" {
  source = "./modules/ecs-cluster"
}

module "agent_dynamodb" {
  source = "./modules/dynamodb-agent"
}

module "analytics_s3" {
  source = "./modules/s3-analytics"
}

module "iam_services" {
  source = "./modules/iam-services"
}

module "kafka" {
  source = "./modules/kafka"
  subnet = module.networking.public_subnets[0]
}

module "execution_agent" {
  source        = "./modules/ecs-service"
  name          = "execution-agent"
  image         = var.service_image_map["execution-agent"]
  cluster_id    = module.ecs_cluster.cluster_id
  subnets       = module.networking.public_subnets
  task_role_arn = module.iam_services.task_role_arn
}