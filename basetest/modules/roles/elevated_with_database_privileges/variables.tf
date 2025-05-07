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

variable "database_privileges" {
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