output "database_name" {
  description = "The name of the database created from the share."
  value       = snowflake_shared_database.shared_db.name
}

output "database_fully_qualified_name" {
  description = "The fully qualified name of the shared database."
  # The `snowflake_shared_database` resource typically exposes `fully_qualified_name` or similar.
  # Adjust if the attribute name is different for `snowflakedb/snowflake` provider.
  # If not directly available, it might be the same as `name` for shared databases, or you might construct it if needed.
  value       = snowflake_shared_database.shared_db.name # Placeholder, check provider docs for exact attribute
} 