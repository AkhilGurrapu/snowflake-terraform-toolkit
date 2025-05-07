resource "snowflake_schema" "schema" {
  name     = var.schema_name
  comment  = var.comment
  database = var.database_name
}

resource "snowflake_grant_privileges_to_account_role" "grant_usage_sysops_role" {
  privileges        = ["USAGE"]
  account_role_name = "SYSOPS"
  on_schema {
    all_schemas_in_database = var.database_name
  }
  depends_on = [snowflake_schema.schema]
}

resource "snowflake_grant_privileges_to_account_role" "grant_usage_securityadmin_role" {
  privileges        = ["USAGE"]
  account_role_name = "SECURITYADMIN"
  on_schema {
    all_schemas_in_database = var.database_name
  }
  depends_on = [snowflake_schema.schema]
}

resource "snowflake_grant_ownership" "grant_ownership_to_schema" {
  account_role_name   = "SYSADMIN"
  outbound_privileges = "COPY"
  on {
    object_type = "SCHEMA"
    object_name = "${var.database_name}.${var.schema_name}"
  }
}