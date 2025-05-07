output "database_names" {
  description = "The names of the created databases"
  value = [ for db in snowflake_database.database_name_types : db.name ]
}
