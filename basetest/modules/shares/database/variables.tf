variable "database_name" {
  description = "The name of the database to be created from the share."
  type        = string
}

variable "share_name" {
  description = "The fully qualified name of the share (e.g., orgname.accountname.sharename)."
  type        = string
}

variable "comment" {
  description = "Specifies a comment for the shared database."
  type        = string
  default     = null
}

variable "grant_imported_privileges_to_role" {
  description = "Optional: The account role to grant IMPORTED PRIVILEGES on the database. If empty or null, no grant is made."
  type        = string
  default     = null
} 