variable "shared_db_configs" {
  description = "A map of configurations for creating databases from shares. The key is a logical identifier."
  type = map(object({
    database_name                      = string
    from_share                         = string
    comment                            = optional(string, "Database created from share by Terraform")
    grant_imported_privileges_to_roles = optional(list(string), [])
  }))
  default = {}
} 