variable "schemas_config" {
  description = "A map of schema configurations. The key is the schema name (without the database prefix)."
  type = map(object({
    database_name        = string
    comment              = optional(string, "Schema managed by Terraform")
    owner_role           = optional(string, "SYSADMIN") // Role to own the schema
    usage_grant_to_roles = optional(list(string), [])   // Roles to grant USAGE on this specific schema
  }))
  default = {}
}

/*
// Old variables - to be replaced
variable "schema_name" {
  description = "The name of the schema to be created"
  type        = string
}

variable "database_name" {
  description = "The name of the database where the schema will be created"
  type        = string
}

variable "comment" {
  description = "Optional comment for the schema"
  type        = string
  default     = null
}
*/