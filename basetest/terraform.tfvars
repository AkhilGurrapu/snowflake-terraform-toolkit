# Authentication parameters
snowflake_username = "your_snowflake_username"  # Replace with your Snowflake username
snowflake_role = "ACCOUNTADMIN"  # Replace with appropriate role
private_key_path = "/path/to/your/rsa_key.p8"  # Path to your private key
private_key_passphrase = "your_passphrase"  # Only if your key has a passphrase

# Account parameters
account_name = "RGARE-APPOC"  # Replace with your Snowflake account name
environment = "poc"

# Storage integration parameters (only needed if you're setting up integrations)
storage_integration_name = "AWS_S3_INTEGRATION"
storage_integration_comment = "Integration with AWS S3"
storage_integration_type = "EXTERNAL_STAGE"
storage_integration_provider = "S3"
storage_integration_arn = "arn:aws:iam::123456789012:role/snowflake-integration-role"
storage_integration_external_id = "external_id"
storage_integration_enabled = true
storage_integration_allowed_locations = [
  "s3://your-bucket-name/path/"
] 