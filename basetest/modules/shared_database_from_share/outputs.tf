output "created_shared_databases" {
  description = "A map of the shared databases created, keyed by the input map key."
  value = {
    for db_key, db_instance in snowflake_shared_database.shared_db :
    db_key => {
      name           = db_instance.name
      from_share     = db_instance.from_share
      comment        = db_instance.comment
      owner          = db_instance.owner // Note: owner might be the role used by provider or a default
      retention_time = db_instance.data_retention_time_in_days
    }
  }
} 