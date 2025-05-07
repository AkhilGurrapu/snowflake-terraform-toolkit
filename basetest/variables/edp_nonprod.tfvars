environment = "SDLC"
snowflake_role = "ACCOUNTADMIN"
account_name = "EDPNONPROD"

#-----------STORAGE INTEGRATION----------------
storage_integration_name = "EDP_SNOWFLAKE_INTEGRATION_SDLC"
storage_integration_comment = "EDP Snowflake Integration for AWS SDLC account."
storage_integration_type = "EXTERNAL_STAGE"
storage_integration_provider = "S3"
storage_integration_arn = "arn:aws:iam::034251436228:role/edp-snowflake-integration-sdlc"
storage_integration_external_id = "QFB19184_SFCRole=2_esoL6om6D0ZqIQuT+OuoJHhPeC8="
storage_integration_enabled = true
storage_integration_allowed_locations = [
  "s3://edp-store-034251436228-app-dev/ingress",
  "s3://edp-store-034251436228-app-test/ingress",
  "s3://edp-store-034251436228-app-dev/egress",
  "s3://edp-store-034251436228-app-test/egress"
]

