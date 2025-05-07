resource "snowflake_warehouse" "warehouse" {
  for_each = var.warehouses

  name                                = each.key
  warehouse_size                      = each.value.size
  auto_suspend                        = each.value.auto_suspend
  auto_resume                         = each.value.auto_resume
  initially_suspended                 = each.value.initially_suspended
  scaling_policy                      = each.value.scaling_policy
  max_cluster_count                   = each.value.max_cluster_count
  min_cluster_count                   = each.value.min_cluster_count
  enable_query_acceleration           = each.value.enable_query_acceleration
  comment                             = each.value.comment
}

resource "snowflake_grant_ownership" "warehouse_ownership" {
  for_each = var.warehouses

  account_role_name = "SYSADMIN"
  on {
    object_type = "WAREHOUSE"
    object_name = snowflake_warehouse.warehouse[each.key].name
  }

  depends_on = [snowflake_warehouse.warehouse]
}

resource "snowflake_grant_privileges_to_account_role" "grant_usage_admin_wh_func_pt_security" {
  privileges        = ["USAGE"]
  account_role_name = "FUNC_PT_SECURITY"
  on_account_object {
    object_type = "WAREHOUSE"
    object_name = "ADMIN_WH"
  }
}

resource "snowflake_grant_privileges_to_account_role" "grant_usage_admin_wh_secops" {
  privileges        = ["USAGE"]
  account_role_name = "SECOPS"
  on_account_object {
    object_type = "WAREHOUSE"
    object_name = "ADMIN_WH"
  }
}

resource "snowflake_grant_privileges_to_account_role" "grant_usage_admin_wh_securityadmin" {
  privileges        = ["USAGE"]
  account_role_name = "SECURITYADMIN"
  on_account_object {
    object_type = "WAREHOUSE"
    object_name = "ADMIN_WH"
  }
}

resource "snowflake_grant_privileges_to_account_role" "grant_usage_admin_wh_sysops" {
  privileges        = ["USAGE"]
  account_role_name = "SYSOPS"
  on_account_object {
    object_type = "WAREHOUSE"
    object_name = "ADMIN_WH"
  }
}