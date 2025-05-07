resource "snowflake_account_role" "role" {
  name    = var.role_name
  comment = "Role owned by ${var.owner_role}"

  lifecycle {
    prevent_destroy = false
  }
}

resource "snowflake_grant_account_role" "ownership" {
  role_name        = snowflake_account_role.role.name
  parent_role_name = var.owner_role
  depends_on       = [snowflake_account_role.role]
}

resource "snowflake_grant_privileges_to_account_role" "privileges" {
  account_role_name = snowflake_account_role.role.name
  privileges        = var.privileges
  on_account        = true
}

resource "snowflake_grant_account_role" "grants" {
  for_each = toset(var.grants)

  role_name        = each.value
  parent_role_name = snowflake_account_role.role.name
}

resource "snowflake_grant_privileges_to_database_role" "database_privileges" {
  for_each = var.database_privileges

  privileges         = each.value.privileges
  database_role_name = "${each.value.database}.${snowflake_account_role.role.name}"
  on_database        = each.value.database
}