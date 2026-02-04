# AWS Configuration
variable "aws_region" {
  description = "AWS region"
  type        = string
  default     = "us-east-1"
}

variable "environment" {
  description = "Environment name"
  type        = string
  default     = "main"
}

variable "project_name" {
  description = "Project name"
  type        = string
  default     = "trading-platform"
}

# Networking
variable "vpc_cidr" {
  description = "VPC CIDR block"
  type        = string
  default     = "10.0.0.0/16"
}

variable "availability_zones" {
  description = "Availability zones"
  type        = list(string)
  default     = ["us-east-1a", "us-east-1b"]
}

# EKS Configuration
variable "eks_cluster_version" {
  description = "EKS cluster version"
  type        = string
  default     = "1.28"
}

variable "eks_node_groups" {
  description = "EKS node groups configuration"
  type = map(object({
    desired_size   = number
    min_size       = number
    max_size       = number
    instance_types = list(string)
    capacity_type  = string
  }))
  default = {
    general = {
      desired_size   = 2
      min_size       = 1
      max_size       = 4
      instance_types = ["t3.medium"]
      capacity_type  = "SPOT"
    }
  }
}

# RDS Configuration
variable "rds_instance_class" {
  description = "RDS instance class"
  type        = string
  default     = "db.t4g.micro"
}

variable "rds_allocated_storage" {
  description = "RDS allocated storage in GB"
  type        = number
  default     = 20
}

variable "rds_engine_version" {
  description = "PostgreSQL engine version"
  type        = string
  default     = "15.4"
}

variable "rds_database_name" {
  description = "Database name"
  type        = string
  default     = "tradingdb"
}

variable "rds_master_username" {
  description = "RDS master username"
  type        = string
  default     = "dbadmin"
}

variable "rds_master_password" {
  description = "RDS master password"
  type        = string
  sensitive   = true
}

variable "rds_multi_az" {
  description = "Enable Multi-AZ"
  type        = bool
  default     = false
}

variable "rds_backup_retention" {
  description = "Backup retention period in days"
  type        = number
  default     = 7
}

# Redis Configuration
variable "redis_node_type" {
  description = "Redis node type"
  type        = string
  default     = "cache.t4g.micro"
}

variable "redis_num_cache_nodes" {
  description = "Number of cache nodes"
  type        = number
  default     = 1
}

variable "redis_engine_version" {
  description = "Redis engine version"
  type        = string
  default     = "7.0"
}

# Kinesis Configuration
variable "kinesis_streams" {
  description = "Kinesis streams configuration"
  type = map(object({
    shard_count      = number
    retention_period = number
  }))
  default = {
    order-events = {
      shard_count      = 2
      retention_period = 24
    }
    market-data = {
      shard_count      = 2
      retention_period = 24
    }
    execution-events = {
      shard_count      = 2
      retention_period = 24
    }
  }
}

# S3 Configuration
variable "s3_buckets" {
  description = "S3 buckets configuration"
  type = map(object({
    versioning = bool
    lifecycle_rules = list(object({
      id      = string
      enabled = bool
      transition = list(object({
        days          = number
        storage_class = string
      }))
    }))
  }))
  default = {
    model-artifacts = {
      versioning = true
      lifecycle_rules = [{
        id      = "archive-old-models"
        enabled = true
        transition = [{
          days          = 90
          storage_class = "GLACIER"
        }]
      }]
    }
    market-data-lake = {
      versioning = true
      lifecycle_rules = [{
        id      = "intelligent-tiering"
        enabled = true
        transition = [{
          days          = 30
          storage_class = "INTELLIGENT_TIERING"
        }]
      }]
    }
    backups = {
      versioning = true
      lifecycle_rules = [{
        id      = "expire-old-backups"
        enabled = true
        transition = [{
          days          = 30
          storage_class = "DEEP_ARCHIVE"
        }]
      }]
    }
  }
}

# ECR Configuration
variable "ecr_repositories" {
  description = "ECR repositories"
  type        = list(string)
  default = [
    "order-service",
    "execution-service",
    "market-data-service",
    "ai-agent-service",
    "analytics-service",
    "risk-service"
  ]
}

# CloudWatch Configuration
variable "cloudwatch_log_retention_days" {
  description = "CloudWatch log retention in days"
  type        = number
  default     = 3
}
