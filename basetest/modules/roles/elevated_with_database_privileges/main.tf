resource "snowflake_account_role" "role" {
  for_each = var.elevated_roles

  name    = each.key
  comment = each.value.comment

  lifecycle {
    prevent_destroy = false
  }
}

resource "snowflake_grant_ownership" "ownership" {
  for_each = var.elevated_roles

  account_role_name   = each.value.owner_role
  outbound_privileges = each.value.outbound_privileges
  on {
    object_type = "ROLE"
    object_name = snowflake_account_role.role[each.key].name
  }
  depends_on = [snowflake_account_role.role]
}

// Grant IMPORTED PRIVILEGES on a specific database
resource "snowflake_database_grant" "imported_privileges" {
  for_each = { 
    for role_key, role_config in var.elevated_roles : role_key => role_config 
    if role_config.imported_privileges_on_database != null && role_config.imported_privileges_on_database != ""
  }

  database_name = each.value.imported_privileges_on_database
  privilege     = "IMPORTED PRIVILEGES"
  roles         = [snowflake_account_role.role[each.key].name]
  
  depends_on = [snowflake_account_role.role]
}

// Grant the newly created role TO other specified roles
resource "snowflake_grant_account_role" "grants" {
  for_each = merge(
    flatten([
      for role_key, role_config in var.elevated_roles :
        [
          for grant_to_role in coalesce(role_config.grants, []) :
            {
              "${role_key}_to_${grant_to_role}" = { 
                created_role_name  = snowflake_account_role.role[role_key].name, 
                grant_to_role_name = grant_to_role 
              }
            }
        ]
    ])...
  )

  role_name        = each.value.grant_to_role_name       // The role being granted TO (e.g., ANALYST_ROLE)
  parent_role_name = each.value.created_role_name      // The role being granted (e.g., ACCOUNT_USAGE_VIEWER)
  depends_on       = [snowflake_account_role.role]
}

// Grant USAGE on the newly created role TO its owner
resource "snowflake_grant_account_role" "grant_usage_to_owner" {
  for_each = var.elevated_roles

  role_name        = snowflake_account_role.role[each.key].name
  parent_role_name = each.value.owner_role
  depends_on       = [snowflake_account_role.role]
}

// Handle schema object grants (e.g., SELECT ON ALL VIEWS IN SCHEMA)
resource "snowflake_grant_privileges_to_role" "schema_object_privs" {
  for_each = merge(
    flatten([
      for role_key, role_config in var.elevated_roles :
        [
          for grant_key, grant_config in coalesce(role_config.schema_object_grants, {}) :
            {
              "${role_key}_grant_${grant_key}" = { // Ensured unique key per grant instance
                created_role_name    = snowflake_account_role.role[role_key].name,
                database_name        = grant_config.database_name,
                schema_name          = grant_config.schema_name,
                object_type_plural = grant_config.object_type_plural,
                privileges           = grant_config.privileges
              }
            }
        ]
    ])...
  )

  role_name  = each.value.created_role_name
  privileges = each.value.privileges

  on_schema_object {
    all {
      object_type_plural = each.value.object_type_plural
      in_schema {
        database_name = each.value.database_name
        schema_name   = each.value.schema_name
      }
    }
  }
  depends_on = [snowflake_account_role.role]
}