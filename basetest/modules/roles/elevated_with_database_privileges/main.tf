resource "snowflake_account_role" "role" {
  name    = var.role_name
  comment = "Role owned by ${var.owner_role}"

  lifecycle {
    prevent_destroy = false
  }
}

resource "snowflake_grant_ownership" "ownership" {
  account_role_name   = snowflake_account_role.role.name
  outbound_privileges = var.outbound_privileges
  on {
    object_type = "ROLE"
    object_name = snowflake_account_role.role.name
  }

  depends_on = [snowflake_account_role.role]
}

resource "snowflake_grant_privileges_to_account_role" "imported_privileges" {
  account_role_name = snowflake_account_role.role.name
  privileges        = var.imported_privileges.privileges
  on_account_object {
    object_type = "DATABASE"
    object_name = var.imported_privileges.database
  }

  depends_on = [snowflake_account_role.role]
}

resource "snowflake_grant_account_role" "grants" {
  for_each = toset(var.grants)

  role_name        = each.value
  parent_role_name = snowflake_account_role.role.name
}

resource "snowflake_grant_account_role" "grant_sysops_usage" {
  role_name        = snowflake_account_role.role.name
  parent_role_name = var.owner_role
  depends_on       = [snowflake_account_role.role]
}