resource "snowflake_shared_database" "shared_db" {
  name       = var.database_name
  from_share = var.share_name
  comment    = var.comment
}

resource "snowflake_grant_privileges_to_account_role" "imported_privs_grant" {
  count             = var.grant_imported_privileges_to_role != null && var.grant_imported_privileges_to_role != "" ? 1 : 0

  account_role_name = var.grant_imported_privileges_to_role
  privileges        = ["IMPORTED PRIVILEGES"]

  on_account_object {
    object_type = "DATABASE"
    object_name = snowflake_shared_database.shared_db.name
  }

  depends_on = [snowflake_shared_database.shared_db]
} 