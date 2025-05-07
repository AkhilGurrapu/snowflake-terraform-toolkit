output "role_name" {
  description = "The name of the created Snowflake account role."
  value       = snowflake_account_role.role.name
}