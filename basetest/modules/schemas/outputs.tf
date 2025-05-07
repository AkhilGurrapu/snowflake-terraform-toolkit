output "created_schemas" {
  description = "A map of the created schemas and their details."
  value = {
    for schema_key, schema_instance in snowflake_schema.schema :
    schema_key => {
      name     = schema_instance.name
      database = schema_instance.database
      comment  = schema_instance.comment
      // owner = schema_instance.owner // The 'owner' attribute is not directly available on snowflake_schema, ownership is managed by grant
    }
  }
}

/*
// Old single-schema outputs
output "schema_name" {
  description = "The name of the created schema"
  value       = snowflake_schema.schema.name
}

output "schema_database" {
  description = "The database associated with the schema"
  value       = snowflake_schema.schema.database
}
*/