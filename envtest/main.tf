locals {
  snowfake_tags = {
    "project_id"           = "10313" # Used on cost information
    "application_id"       = "10313"
    "business_application" = "Snowflake Platform"
    "application_service"  = "Snowflake_Platform_Aws_${var.environment}"
    "environment_class"    = var.environment
    "service"              = "snowflake"
    "snowflake_account"    = var.account_name
  }
  environments = var.environment == "sdlc" ? ["DEV", "TEST"] : [upper(var.environment)]
  database_names = flatten([
    for env in local.environments : [
      for db_type in var.database_types : {
        name    = "${env}_${db_type}"
        comment = "Database for ${env} environment, type ${db_type}"
      }
    ]
  ])
}

terraform {
  backend "s3" {
    bucket  = var.bucket
    key     = var.key
    region  = var.region
    encrypt = true
  }
}

provider "snowflake" {
  organization_name        = "RGARE"
  account_name             = var.account_name
  user                     = var.snowflake_username
  role                     = var.snowflake_role
  authenticator            = "SNOWFLAKE_JWT"
  private_key              = file(var.private_key_path)
  private_key_passphrase   = var.private_key_passphrase
}

module "databases" {
  source = "./modules/database"
  environment = var.environment
  database_owner_role = "SYSADMIN"
  create_database_role = "SYSOPS"
  database_types = ["RAW", "CUR", "ACC", "BUS", "METADATA"]
}