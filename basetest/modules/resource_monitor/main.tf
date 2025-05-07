resource "snowflake_resource_monitor" "resource_monitor" {
  name                      = var.resource_monitor_name
  credit_quota              = var.credit_quota
  frequency                 = var.frequency
  start_timestamp           = var.start_timestamp
  end_timestamp             = var.end_timestamp
  notify_triggers           = var.notify_triggers
  suspend_trigger           = var.suspend_trigger
  suspend_immediate_trigger = var.suspend_immediate_trigger
  notify_users              = var.notify_users
}