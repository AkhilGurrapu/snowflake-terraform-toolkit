resource "snowflake_account_role" "imported" {
  for_each = var.roles

  name    = each.key
  comment = each.value.comment

  lifecycle {
    prevent_destroy = true
  }
}

resource "snowflake_grant_ownership" "ownership" {
  for_each = var.roles

  account_role_name = each.value.owner_role
  on {
    object_type = "ROLE"
    object_name = each.key
  }

  outbound_privileges = "COPY" # Transfer existing privileges with ownership
  depends_on          = [snowflake_account_role.imported]
}