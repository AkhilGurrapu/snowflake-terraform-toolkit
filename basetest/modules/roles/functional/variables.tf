variable "roles" {
  description = "Map of access roles to create with their attributes"
  type = map(object({
    comment    = string
    owner_role = string
    grants     = optional(list(string), [])
  }))
}