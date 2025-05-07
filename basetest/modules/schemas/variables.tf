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