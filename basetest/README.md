# Terraform Snowflake Setup

This repository contains Terraform configuration to manage a snowflake account.It is designed witha modular
and supports both the creation of new resources and import of existing ones.

## Provider Configuration
- **Authentication:**
    Uses RSA key authentication. The RSA key must be set in the envirohnment variable `SNOWFLAKE_PRIVATE_KEY` 
    and  the passphrease must be set int `SNOWFLAKE_PRIVATE_KEY_PASSPHRASE`. This will be set within the jenkinsfile.

## Modules
- **Roles Module:**
  - Purpose
    - Manage Snowflake account roles
  - Capabilities
    - Create new roles whenteh create flag is set to true.
    - Import existing roles whenthe create flag is set to false.
  - Implementation Details:
    - Two resouce blocked are defined in `modules/roles/main.tf`:
      - `snowflake_account_role.create` for new roles
      - `snowflake_account_role.imported` fo roles to be imported
    - An inline import block is placed in the root `imports.tf` to automatically import roles with `create = false`

## Backend
- **Remote State:**
  - Configured to use a s3 backend. The configuration is provided via backends/{env}.tfvars

## How to Use
- **Setting up AWS credentials**
  - Install [awscli](https://docs.aws.amazon.com/cli/latest/userguide/getting-started-install.html)
    - set the following env variables from the appoc account in aws
      - ```shell
          export AWS_ACCESS_KEY_ID=""
          export AWS_SECRET_ACCESS_KEY=""
          export AWS_SESSION_TOKEN=""
        ```
    - set up your aws credentials and profile with the appoc account information
    - run aws sso login.
      - ```shell
        aws sso login --profile <name>
        ```
- **Initialization**
  - Run the following comman to initialize with the backend configuration
  - ```shell
      terraform init -backend-config=backends/appoc.tfvars
    ```
- **Validate Configuration**
  - ```shell
        terraform validate
    ``` 
- **Plan Changes**
  - ```shell
        terraform plan
    ```

## References
- [Snowflake Terraform Provider v1.0.4](https://registry.terraform.io/providers/Snowflake-Labs/snowflake/latest/docs)
- [Terraform import Blocks Documentation](https://developer.hashicorp.com/terraform/language/import)
