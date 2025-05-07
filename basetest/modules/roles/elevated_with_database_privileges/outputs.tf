output "role_name" {
  description = "The name of the created Snowflake account role."
  value       = snowflake_account_role.role.name
}

output "elevated_roles_details" {
  description = "A map of the created Snowflake account roles, with their names, qualified names, and comments."
  value = {
    for role_key, role_instance in snowflake_account_role.role :
    role_key => {
      name             = role_instance.name
      qualified_name   = role_instance.qualified_name
      comment          = role_instance.comment
      # owner_role     = var.elevated_roles[role_key].owner_role # This is input, not output of the role itself
      # grants_to      = var.elevated_roles[role_key].grants      # This is input
    }
  }
}