resource "snowflake_schema" "schema" {
  for_each = var.schemas_config

  name     = each.key // Schema name is the key of the map
  database = each.value.database_name
  comment  = each.value.comment
}

// Grant USAGE on the specific created schema to specified roles
resource "snowflake_schema_grant" "grant_usage_on_schema" {
  for_each = merge(
    flatten([
      for schema_key, schema_config in var.schemas_config :
      [
        for role_name in coalesce(schema_config.usage_grant_to_roles, []) :
        {
          // Create a unique key for each schema-role grant pair
          "${schema_key}_to_${role_name}" = {
            database_name = schema_config.database_name
            schema_name   = snowflake_schema.schema[schema_key].name // Use the created schema's name
            role_to_grant = role_name
          }
        }
      ]
    ])...
  )

  database_name = each.value.database_name
  schema_name   = each.value.schema_name
  privilege     = "USAGE"
  roles         = [each.value.role_to_grant]
  with_grant_option = false // Typically false for USAGE grants

  depends_on = [snowflake_schema.schema]
}

// Grant OWNERSHIP of the schema to the specified role
resource "snowflake_grant_ownership" "grant_ownership_to_schema" {
  for_each = var.schemas_config

  account_role_name   = each.value.owner_role 
  outbound_privileges = "COPY" // Or consider making this configurable if needed
  on {
    object_type = "SCHEMA"
    // Correctly qualify the schema name with its database from the resource output
    object_name = "\"${snowflake_schema.schema[each.key].database}\".\"${snowflake_schema.schema[each.key].name}\""
  }
  depends_on = [snowflake_schema.schema]
}

/*
// Old, problematic hardcoded grants - to be removed
resource "snowflake_grant_privileges_to_account_role" "grant_usage_sysops_role" {
  privileges        = ["USAGE"]
  account_role_name = "SYSOPS"
  on_schema {
    all_schemas_in_database = var.database_name // This was the old var.database_name
  }
  depends_on = [snowflake_schema.schema]
}

resource "snowflake_grant_privileges_to_account_role" "grant_usage_securityadmin_role" {
  privileges        = ["USAGE"]
  account_role_name = "SECURITYADMIN"
  on_schema {
    all_schemas_in_database = var.database_name // This was the old var.database_name
  }
  depends_on = [snowflake_schema.schema]
}
*/