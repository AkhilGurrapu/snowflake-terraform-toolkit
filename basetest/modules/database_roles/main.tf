resource "snowflake_database_role" "admin" {
  database = var.database_name
  name     = var.database_role_name
  comment  = var.database_role_comment
}

resource "snowflake_grant_database_role" "grant_admin_db_admin_sch_write_to_sysadmin" {
  database_role_name = "${var.database_name}.${var.database_role_name}"
  parent_role_name   = var.parent_role_name
}

resource "snowflake_grant_privileges_to_database_role" "admin_future_views" {
  privileges         = ["APPLYBUDGET", "DELETE", "EVOLVE SCHEMA", "INSERT", "REBUILD", "REFERENCES", "SELECT", "TRUNCATE", "UPDATE"]
  database_role_name = "${var.database_name}.${var.database_role_name}"
  on_schema_object {
    future {
      object_type_plural = "VIEWS"
      in_database        = var.database_name
    }
  }
}


resource "snowflake_grant_privileges_to_database_role" "admin_future_external_tables" {
  privileges         = ["APPLYBUDGET", "DELETE", "EVOLVE SCHEMA", "INSERT", "REBUILD", "REFERENCES", "SELECT", "TRUNCATE", "UPDATE"]
  database_role_name = "${var.database_name}.${var.database_role_name}"
  on_schema_object {
    future {
      object_type_plural = "EXTERNAL TABLES"
      in_database        = var.database_name
    }
  }
}

resource "snowflake_grant_privileges_to_database_role" "admin_future_stages" {
  privileges         = ["USAGE"]
  database_role_name = "${var.database_name}.${var.database_role_name}"
  on_schema_object {
    future {
      object_type_plural = "STAGES"
      in_database        = var.database_name
    }
  }
}

resource "snowflake_grant_privileges_to_database_role" "admin_schema_privileges" {
  privileges         = ["MONITOR", "USAGE"]
  database_role_name = "${var.database_name}.${var.database_role_name}"
  on_schema {
    schema_name = "${var.database_name}.${var.schema_name}"
  }
}

resource "snowflake_grant_privileges_to_database_role" "admin_schema_privileges_create_table" {
  privileges         = ["CREATE TABLE"]
  database_role_name = "${var.database_name}.${var.database_role_name}"
  on_schema {
    schema_name = "${var.database_name}.${var.schema_name}"
  }
}

resource "snowflake_grant_privileges_to_database_role" "admin_schema_privileges_create_external_table" {
  privileges         = ["CREATE EXTERNAL TABLE"]
  database_role_name = "${var.database_name}.${var.database_role_name}"
  on_schema {
    schema_name = "${var.database_name}.${var.schema_name}"
  }
}

resource "snowflake_grant_privileges_to_database_role" "admin_schema_privileges_create_view" {
  privileges         = ["CREATE VIEW"]
  database_role_name = "${var.database_name}.${var.database_role_name}"
  on_schema {
    schema_name = "${var.database_name}.${var.schema_name}"
  }
}

resource "snowflake_grant_privileges_to_database_role" "admin_schema_privileges_create_function" {
  privileges         = ["CREATE FUNCTION"]
  database_role_name = "${var.database_name}.${var.database_role_name}"
  on_schema {
    schema_name = "${var.database_name}.${var.schema_name}"
  }
}

resource "snowflake_grant_privileges_to_database_role" "admin_schema_privileges_create_procedure" {
  privileges         = ["CREATE PROCEDURE"]
  database_role_name = "${var.database_name}.${var.database_role_name}"
  on_schema {
    schema_name = "${var.database_name}.${var.schema_name}"
  }
}

resource "snowflake_grant_privileges_to_database_role" "admin_schema_privileges_create_sequence" {
  privileges         = ["CREATE SEQUENCE"]
  database_role_name = "${var.database_name}.${var.database_role_name}"
  on_schema {
    schema_name = "${var.database_name}.${var.schema_name}"
  }
}

resource "snowflake_grant_ownership" "admin_future_sequences" {
  database_role_name  = "${var.database_name}.${var.database_role_name}"
  on {
    future {
      object_type_plural = "SEQUENCES"
      in_database        = var.database_name
    }
  }
}

resource "snowflake_grant_ownership" "admin_future_tables" {
  database_role_name  = "${var.database_name}.${var.database_role_name}"
  on {
    future {
      object_type_plural = "TABLES"
      in_database        = var.database_name
    }
  }
}