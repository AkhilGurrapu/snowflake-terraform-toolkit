locals {
  snowfake_tags = {
    "project_id"           = "10313" # Used on cost information
    "application_id"       = "10313"
    "business_application" = "Snowflake Platform"
    "application_service"  = "Snowflake_Platform_Aws_${var.environment}"
    "environment_class"    = var.environment
    "service"              = "snowflake"
    "snowflake_account"    = var.account_name
  }
}

terraform {
  backend "s3" {
    bucket  = var.bucket
    key     = var.key
    region  = var.region
    encrypt = true
  }
}

provider "snowflake" {
  organization_name        = "RGARE"
  account_name             = var.account_name
  user                     = var.snowflake_username
  role                     = var.snowflake_role
  authenticator            = "SNOWFLAKE_JWT"
  private_key              = file(var.private_key_path)
  private_key_passphrase   = var.private_key_passphrase
}

module "imported_roles" {
  source = "./modules/roles/imported"

  roles = {
    APP_SNOWFLAKE_ADMIN = {
      comment    = ""
      privileges = [] # No privileges to modify for imported roles
      owner_role = "OKTA_PROVISIONER"
    }
    APP_SNOWFLAKE_USER = {
      comment    = ""
      privileges = [] # No privileges to modify for imported roles
      owner_role = "OKTA_PROVISIONER"
    }
    OKTA_PROVISIONER = {
      comment    = ""
      privileges = [] # No privileges to modify for imported roles
      owner_role = "ACCOUNTADMIN"
    }
  }
}
module "account_roles_base" {
  source = "./modules/roles/base"

  roles = {
    SYSOPS = {
      comment    = "Account-level role for sysops"
      privileges = [
        "APPLY MASKING POLICY",
        "APPLY ROW ACCESS POLICY",
        "APPLY TAG",
        "CREATE INTEGRATION",
        "EXECUTE TASK",
        "CREATE ROLE",
        "MONITOR USAGE"
      ]
      owner_role = "SECURITYADMIN"
    },
    FUTUREOPS = {
      comment    = "Account-level role for futureops"
      privileges = ["MANAGE GRANTS"]
      owner_role = "SECURITYADMIN"
    },
    SECOPS = {
      comment    = "Account-level role for secops"
      privileges = ["MONITOR SECURITY"]
      owner_role = "SECURITYADMIN"
    }
  }
}

module "roles_with_privileges_and_grants" {
  source = "./modules/roles/elevated"
  role_name = "FUNC_PT_SECURITY"
  privileges = ["MANAGE ACCOUNT SUPPORT CASES"]
  grants = ["SYSOPS", "SECOPS"]
  owner_role = "ACCOUNTADMIN"
}

# TODO: Unravel the account usage roles below and create/assign better roles.
// In basetest/main.tf

module "custom_elevated_roles" { // Renamed module instance for clarity
  source = "./modules/roles/elevated_with_database_privileges"

  elevated_roles = {
    "SNOWFLAKE_SHARE_OPS" = {
      comment                         = "Role for Snowflake sharing operations"
      owner_role                      = "SYSOPS"
      // grants                       = [] // Optional, defaults to empty list
      imported_privileges_on_database = "SNOWFLAKE"
      // schema_object_grants         = {} // Optional, defaults to empty map
    }

    "ACCOUNT_USAGE_VIEWER" = {
      comment                         = "Role to view account usage data"
      owner_role                      = "SYSOPS"
      imported_privileges_on_database = "SNOWFLAKE"
      schema_object_grants = {
        "grant_select_on_all_views_in_account_usage" = {
          database_name      = "SNOWFLAKE"
          schema_name        = "ACCOUNT_USAGE"
          object_type_plural = "VIEWS"
          privileges         = ["SELECT"]
        }
      }
    }
  }
}

#TODO: Add conditional possible split so FUNC_EDP_SVC_NP and FUNC_EDP_SVC are created in specified accounts
module "functional_roles" {
  source = "./modules/roles/functional"

  roles = {
    FUNC_EDP_SVC_NP = {
      comment    = "Account-level role for the EDP team"
      owner_role = "ACCOUNTADMIN"
    },
    FUNC_EDP_SVC = {
      comment    = "Account-level role for the EDP team"
      owner_role = "ACCOUNTADMIN"
    },
    FUNC_SVC_SECURITY_NP = {
      comment    = "Account-level role for the EDP team"
      owner_role = "FUNC_PT_SECURITY"
    },
    FUNC_SVC_SECURITY = {
      comment    = "Account-level role for the EDP team"
      owner_role = "FUNC_PT_SECURITY"
    }
  }
  depends_on = [module.roles_with_privileges_and_grants]
}

module "account_level_databases" {
  source                     = "./modules/database"
  database_name              = "ADMIN_DB"
  comment                    = "Analytics Platforms database for account level utilities."
  database_owner_role        = "SYSADMIN"
  usage_roles                = ["FUNC_EDP_SVC", "FUNC_EDP_SVC_NP", "SECURITYADMIN", "SYSOPS"]
  create_database_role       = "SYSOPS"
  depends_on                 = [module.functional_roles]
}

module "admin_schema" {
  source                     = "./modules/schemas"
  schema_name                = "ADMIN_SCH"
  database_name              = "ADMIN_DB"
  comment                    = "Analytics Platforms schema for account level utilities."
  depends_on                 = [module.account_level_databases]
}

module "admin_database_role" {
  source                     = "./modules/database_roles"
  database_name              = "ADMIN_DB"
  database_role_name         = "ADMIN_DB_ADMIN_SCH_WRITE"
  database_role_comment      = "Analytics Platforms database role for account level utilities."
  parent_role_name           = "SYSADMIN"
  schema_name                = "ADMIN_SCH"
  depends_on                 = [module.admin_schema]
}

module "warehouses" {
  source = "./modules/warehouse"

  warehouses = {
    EDP_WH = {
      size                        = "XSMALL"
      auto_suspend                = 60
      auto_resume                 = true
      initially_suspended         = true
      scaling_policy              = "STANDARD"
      max_cluster_count           = 3
      min_cluster_count           = 1
      enable_query_acceleration   = false
      comment                     = "EDP warehouse"
    }
    SECURITY_WH = {
      size                        = "XSMALL"
      auto_suspend                = 60
      auto_resume                 = true
      initially_suspended         = true
      scaling_policy              = "STANDARD"
      max_cluster_count           = 3
      min_cluster_count           = 1
      enable_query_acceleration   = false
      comment                     = "Security WH"
    },
    ADMIN_WH = {
      size                        = "XSMALL"
      auto_suspend                = 60
      auto_resume                 = true
      initially_suspended         = true
      scaling_policy              = "STANDARD"
      max_cluster_count           = 1
      min_cluster_count           = 1
      enable_query_acceleration   = false
      comment                     = "Admin WH"
    }
  }
}

module "uat_shared_databases" {
  source = "../../basetest/modules/shared_database_from_share" // Adjust path as needed

  shared_db_configs = {
    "sp_global_ext_db" = { // A logical key for this configuration
      database_name = "SP_GLOBAL_EXT"
      from_share    = "SPGLOBALXPRESSCLOUD.SPGLOBALXPRESSCLOUD_AWS_US_EAST_1.XF_RGAREINSURANCECOMPANY"
      comment       = "S&P Global External data for UAT from XpressFeed share"
      grant_imported_privileges_to_roles = [
        "edp_uat_inv_xpressfeed_viewer" 
        // Add other roles if needed, e.g., "ANOTHER_UAT_ROLE"
      ]
    }

    // You could define other databases from other shares here for UAT
    // "another_shared_db_for_uat" = { ... }
  }
}

# TODO: When integrations become stable, will be utilized here. Currently in gap automation repo.
# module "edp_aws_sdlc" {
#   source                    = "modules/integrations/storage"
#   name                      = var.storage_integration_name
#   comment                   = var.storage_integration_comment
#   type                      = var.storage_integration_type
#   storage_provider          = var.storage_integration_provider
#   aws_iam_user_arn          = var.storage_integration_arn
#   aws_external_id           = var.storage_integration_external_id
#   enabled                   = var.storage_integration_enabled
#   storage_allowed_locations = var.storage_integration_allowed_locations
# }

# TODO: IMPORT ADMIN_WH