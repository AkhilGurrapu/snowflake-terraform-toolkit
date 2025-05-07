resource "snowflake_shared_database" "shared_db" {
  for_each = var.shared_db_configs

  name       = each.value.database_name
  from_share = each.value.from_share
  comment    = each.value.comment
}

// Grant IMPORTED PRIVILEGES on the created shared databases to specified roles
resource "snowflake_database_grant" "grant_imported_privs" {
  for_each = merge(
    flatten([
      for db_key, db_config in var.shared_db_configs :
      [
        for role_name in coalesce(db_config.grant_imported_privileges_to_roles, []) :
        {
          // Create a unique key for each db-role pair grant
          "${db_key}_to_${role_name}" = {
            database_name = snowflake_shared_database.shared_db[db_key].name
            role_to_grant = role_name
          }
        }
        // No explicit 'if' here, as an empty 'grant_imported_privileges_to_roles' list will result in no items for this db_key
      ]
    ])...
  )

  database_name = each.value.database_name
  privilege     = "IMPORTED PRIVILEGES"
  roles         = [each.value.role_to_grant]

  // Ensure the database exists before trying to grant privileges on it
  depends_on = [snowflake_shared_database.shared_db]
} 