variable "database_name" {
  description = "The name of the Snowflake database to be created"
  type        = string
}

variable "comment" {
  description = "A comment for the Snowflake database"
  type        = string
  default     = null
}

variable "usage_roles" {
  description = "List of roles to be granted USAGE privilege on the database"
  type        = list(string)
}

variable "database_owner_role" {
  description = "The role to be granted OWNERSHIP privilege on the database"
  type        = string
}

variable "create_database_role" {
  description = "The account role to be granted CREATE DATABASE ROLE privilege"
  type        = string
}