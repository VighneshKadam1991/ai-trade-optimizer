terraform {
  required_version = ">= 1.5.0"
  
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "~> 2.23"
    }
  }
}

provider "aws" {
  region = var.aws_region

  default_tags {
    tags = {
      Project     = "TradingPlatform"
      Environment = var.environment
      ManagedBy   = "Terraform"
      DeployedBy  = "GitHubActions"
    }
  }
}

# EKS authentication
data "aws_eks_cluster" "cluster" {
  name       = module.eks.cluster_name
  depends_on = [module.eks]
}

data "aws_eks_cluster_auth" "cluster" {
  name       = module.eks.cluster_name
  depends_on = [module.eks]
}

provider "kubernetes" {
  host                   = data.aws_eks_cluster.cluster.endpoint
  cluster_ca_certificate = base64decode(data.aws_eks_cluster.cluster.certificate_authority[0].data)
  token                  = data.aws_eks_cluster_auth.cluster.token
}

# VPC Module
module "vpc" {
  source = "./modules/networking"

  environment        = var.environment
  vpc_cidr          = var.vpc_cidr
  availability_zones = var.availability_zones
  project_name      = var.project_name
}

# EKS Module
module "eks" {
  source = "./modules/eks"

  environment        = var.environment
  cluster_name       = "${var.project_name}-${var.environment}"
  cluster_version    = var.eks_cluster_version
  vpc_id            = module.vpc.vpc_id
  private_subnet_ids = module.vpc.private_subnet_ids
  node_groups       = var.eks_node_groups
  
  depends_on = [module.vpc]
}

# RDS Module
module "rds" {
  source = "./modules/rds"

  environment                = var.environment
  identifier                 = "${var.project_name}-${var.environment}"
  vpc_id                    = module.vpc.vpc_id
  subnet_ids                = module.vpc.private_subnet_ids
  instance_class            = var.rds_instance_class
  allocated_storage         = var.rds_allocated_storage
  engine_version            = var.rds_engine_version
  database_name             = var.rds_database_name
  master_username           = var.rds_master_username
  master_password           = var.rds_master_password
  multi_az                  = var.rds_multi_az
  backup_retention          = var.rds_backup_retention
  allowed_security_group_ids = [module.eks.cluster_security_group_id]
  
  depends_on = [module.vpc]
}

# Redis Module
module "redis" {
  source = "./modules/redis"

  environment                = var.environment
  cluster_id                 = "${var.project_name}-${var.environment}"
  vpc_id                    = module.vpc.vpc_id
  subnet_ids                = module.vpc.private_subnet_ids
  node_type                 = var.redis_node_type
  num_cache_nodes           = var.redis_num_cache_nodes
  engine_version            = var.redis_engine_version
  allowed_security_group_ids = [module.eks.cluster_security_group_id]
  
  depends_on = [module.vpc]
}

# Kinesis Module
module "kinesis" {
  source = "./modules/kinesis"

  environment  = var.environment
  project_name = var.project_name
  streams      = var.kinesis_streams
}

# S3 Module
module "s3" {
  source = "./modules/s3"

  environment  = var.environment
  project_name = var.project_name
  buckets      = var.s3_buckets
}

# ECR Module
module "ecr" {
  source = "./modules/ecr"

  environment  = var.environment
  project_name = var.project_name
  repositories = var.ecr_repositories
}

# IAM Module
module "iam" {
  source = "./modules/iam"

  environment           = var.environment
  project_name          = var.project_name
  eks_cluster_name      = module.eks.cluster_name
  eks_oidc_provider_arn = module.eks.oidc_provider_arn
  s3_bucket_arns        = [for bucket in module.s3.bucket_arns : bucket]
  
  depends_on = [module.eks, module.s3]
}

# Monitoring Module
module "monitoring" {
  source = "./modules/monitoring"

  environment        = var.environment
  project_name       = var.project_name
  cluster_name       = module.eks.cluster_name
  log_retention_days = var.cloudwatch_log_retention_days
  
  depends_on = [module.eks]
}

# Secrets Module
module "secrets" {
  source = "./modules/secrets"

  environment  = var.environment
  project_name = var.project_name
  
  secrets = {
    rds_password = {
      description   = "RDS master password"
      secret_string = var.rds_master_password
    }
  }
}
