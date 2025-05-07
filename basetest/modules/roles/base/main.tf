resource "snowflake_account_role" "created" {
  for_each = var.roles

  name    = each.key
  comment = each.value.comment

  lifecycle {
    prevent_destroy = false
  }
}

resource "snowflake_grant_privileges_to_account_role" "grant_privileges" {
  for_each = var.roles

  account_role_name = each.key
  privileges        = each.value.privileges
  on_account        = true
}

resource "snowflake_grant_ownership" "ownership" {
  for_each = var.roles

  account_role_name = each.value.owner_role
  on {
    object_type = "ROLE"
    object_name = each.key
  }

  outbound_privileges = "COPY" # Transfer existing privileges with ownership
}

resource "snowflake_grant_account_role" "grant_usage_to_secops" {
  role_name        = "SECURITYADMIN"
  parent_role_name = "SECOPS"
}

resource "snowflake_grant_account_role" "grant_usage_to_futureops" {
  role_name        = "SYSADMIN"
  parent_role_name = "FUTUREOPS"
}

resource "snowflake_grant_account_role" "grant_sysops_to_sysadmin" {
  role_name        = "SYSOPS"
  parent_role_name = "SYSADMIN"
}

resource "snowflake_grant_account_role" "grant_accountadmin_to_futureops" {
  role_name        = "FUTUREOPS"
  parent_role_name = "ACCOUNTADMIN"
}
