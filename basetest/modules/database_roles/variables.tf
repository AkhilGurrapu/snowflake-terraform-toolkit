variable "database_name" {
  description = "The name of the database where the database role will be created"
  type        = string
}

variable "database_role_name" {
  description = "The name of the database role to be created"
  type        = string
}

variable "database_role_comment" {
  description = "Optional comment for the database role"
  type        = string
  default     = null
}

variable "schema_name" {
  description = "The name of the schema where the database role will be granted privileges"
  type        = string
  default     = null
}

variable "parent_role_name" {
  description = "The name of the parent role to which the database role will be granted"
  type        = string
  default     = null
}