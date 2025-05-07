output "role_names" {
  description = "The names of the created Snowflake roles"
  value       = keys(snowflake_account_role.created)
}
