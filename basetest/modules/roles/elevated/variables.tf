variable "role_name" {
  description = "Name of the Snowflake role"
  type        = string
}

variable "privileges" {
  description = "List of privileges to assign to the role"
  type        = list(string)
  default     = []
}

variable "grants" {
  description = "List of roles to grant this role to"
  type        = list(string)
  default     = []
}

variable "owner_role" {
  description = "Role that will own the created role"
  type        = string
  default     = "ACCOUNTADMIN"
}

variable "database_privileges" {
  description = "A map of database-specific privileges to grant to the role"
  type = map(object({
    privileges = list(string)
    database   = string
  }))
  default = {}
}