resource "snowflake_account_parameter" "param" {
  key   = var.parameter_key
  value = var.parameter_value
} 