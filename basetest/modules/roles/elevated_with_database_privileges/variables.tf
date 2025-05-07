variable "elevated_roles" {
  description = "A map of elevated roles to create. The key is the role name."
  type = map(object({
    comment                         = optional(string, "Managed by Terraform")
    owner_role                      = string
    grants                          = optional(list(string), []) // Roles to which this new role will be granted
    imported_privileges_on_database = optional(string, null)    // Database to grant IMPORTED PRIVILEGES on. If null, grant is skipped.
    outbound_privileges             = optional(string, "COPY")   // For ownership grant
    schema_object_grants = optional(map(object({              // For grants like SELECT ON ALL VIEWS IN SCHEMA
      database_name      = string
      schema_name        = string
      object_type_plural = string // e.g., "TABLES", "VIEWS"
      privileges         = list(string)
    })), {})
  }))
  default = {}
}

// The following original variables will be replaced by the 'elevated_roles' map structure.
// You can remove them once the module callers are updated.
/*
variable "role_name" {
  description = "The name of the Snowflake account role."
  type        = string
}

variable "owner_role" {
  description = "The parent role that owns this role."
  type        = string
}

variable "grants" {
  description = "Roles to which this role will be granted."
  type        = list(string)
  default     = []
}

variable "database_privileges" { // This was unused in the original main.tf, consider removing if not planned for use.
  description = "Database privileges to grant to the role."
  type = map(object({
    privileges = list(string)
    database   = string
  }))
  default = {}
}

variable "imported_privileges" {
  description = "Privileges to import for the role."
  type = object({
    privileges = list(string)
    database   = string
  })
  default = {
    privileges = ["IMPORTED PRIVILEGES"]
    database   = ""
  }
}

variable "outbound_privileges" {
  description = "Privileges to transfer with ownership."
  type        = string
  default     = "COPY"
}

variable "schema_object_grants" {
  description = "Grants on specific object types within a schema (e.g., SELECT on ALL VIEWS)."
  type = map(object({
    database_name      = string
    schema_name        = string
    object_type_plural = string // e.g., "TABLES", "VIEWS"
    privileges         = list(string)
  }))
  default = {}
}
*/