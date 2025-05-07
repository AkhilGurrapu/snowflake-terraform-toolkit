resource "snowflake_database" "database" {
  name    = var.database_name
  comment = var.comment
}

resource "snowflake_grant_privileges_to_account_role" "grant_create_database_role" {
  privileges        = ["CREATE DATABASE ROLE"]
  account_role_name = var.create_database_role
  on_account_object {
    object_type = "DATABASE"
    object_name = snowflake_database.database.name
  }
}

resource "snowflake_grant_privileges_to_account_role" "grant_usage_roles" {
  for_each = toset(var.usage_roles)
  privileges        = ["USAGE"]
  account_role_name = each.key
  on_account_object {
    object_type = "DATABASE"
    object_name = snowflake_database.database.name
  }
}

resource "snowflake_grant_ownership" "grant_ownership_to_database" {
  account_role_name = var.database_owner_role
  on {
    object_type = "DATABASE"
    object_name = snowflake_database.database.name
  }
}