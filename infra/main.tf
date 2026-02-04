module "networking" {
  source      = "./modules/networking"
  environment = var.environment
}

module "ecs" {
  source      = "./modules/ecs"
  environment = var.environment
  vpc_id      = module.networking.vpc_id
  subnets     = module.networking.private_subnets
}

module "dynamodb" {
  source      = "./modules/dynamodb"
  environment = var.environment
}