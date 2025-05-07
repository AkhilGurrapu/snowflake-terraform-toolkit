variable "roles" {
  description = "Map of roles to create with their attributes"
  type = map(object({
    comment    = string
    privileges = list(string)
    owner_role = string
  }))
}
