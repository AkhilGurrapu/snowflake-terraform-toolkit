terraform {
  required_version = ">= 1.11.1"
  required_providers {
    snowflake = {
      source = "snowflakedb/snowflake"
      version = "~> 1.1.0"
    }
  }
}
