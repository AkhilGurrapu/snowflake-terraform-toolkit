variable "environment" {
  description = "The environment for which the database is being created"
  type = string
}

variable "database_types" {
  description = "Types of databases to align with EDP (RAW, CUR, ACC)."
  type = list(string)
}

variable "database_owner_role" {
  description = "The role to be granted OWNERSHIP privilege on the database"
  type        = string
}

variable "create_database_role" {
  description = "The account role to be granted CREATE DATABASE ROLE privilege"
  type        = string
}