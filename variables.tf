variable "subscription_id" {
  description = "The Azure Subscription ID"
  type        = string
}

variable "tags" {
  type        = map(string)
  description = "A map of tags to apply to all resources"
  default = {
    environment = "development"
    date        = "jul-2025"
    createdBy   = "JCastillo-Dev"
  }
}

variable "project" {
  type        = string
  description = "The name of the project"
  default     = "pipelinejc"
}

variable "environment" {
  type        = string
  description = "The environment to deploy all resources"
  default     = "dev"
}

variable "location" {
  type        = string
  description = "The Azure region to deploy resources"
  default     = "Central US"
}

variable "admin_sql_username" {
  type        = string
  description = "Password of the SQL Database"
}

variable "admin_sql_password" {
  type        = string
  description = "Password of the SQL Database"
}

variable "port" {
  type        = string
  description = "API port"
}

variable "db_type" {
  type        = string
  description = "Database port"
}

variable "db_host" {
  type        = string
  description = "Database host"
}

variable "db_port" {
  type        = string
  description = "Database port"
}

variable "db_name" {
  type        = string
  description = "Database name"
}

# variable "app_insights_name_prefix" {
#   type        = string
#   default     = "appinsights-pipeline"
#   description = "Prefijo para el nombre de Application Insights."
# }

# variable "redis_cache_name_prefix" {
#   type        = string
#   default     = "rediscache-pipeline"
#   description = "Prefijo para el nombre de Azure Cache for Redis."
# }
