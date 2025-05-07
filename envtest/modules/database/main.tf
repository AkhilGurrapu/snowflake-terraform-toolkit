resource "snowflake_database" "database_name_types" {
  for_each = toset(var.database_types)

  name = "${upper(var.environment)}_${each.value}"
  comment = "Database for ${var.environment} environment, type ${each.value}"
}

resource "snowflake_grant_privileges_to_account_role" "grant_create_database_role" {
  for_each = toset(var.database_types)
  privileges        = ["CREATE DATABASE ROLE"]
  account_role_name = var.create_database_role
  on_account_object {
    object_type = "DATABASE"
    object_name = "${upper(var.environment)}_${each.value}"
  }
  depends_on = [snowflake_database.database_name_types]
}

resource "snowflake_grant_privileges_to_account_role" "grant_usage_role" {
  for_each = toset(var.database_types)
  privileges        = ["USAGE"]
  account_role_name = "SYSOPS"
  on_account_object {
    object_type = "DATABASE"
    object_name = "${upper(var.environment)}_${each.value}"
  }
  depends_on = [snowflake_database.database_name_types]
}

resource "snowflake_grant_ownership" "grant_ownership_to_database" {
  for_each = toset(var.database_types)

  account_role_name   = var.database_owner_role
  outbound_privileges = "COPY"
  on {
    object_type = "DATABASE"
    object_name = "${upper(var.environment)}_${each.value}"
  }
  depends_on = [snowflake_grant_privileges_to_account_role.grant_create_database_role]
}