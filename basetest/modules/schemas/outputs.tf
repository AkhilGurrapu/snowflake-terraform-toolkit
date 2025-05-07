output "schema_name" {
  description = "The name of the created schema"
  value       = snowflake_schema.schema.name
}

output "schema_database" {
  description = "The database associated with the schema"
  value       = snowflake_schema.schema.database
}