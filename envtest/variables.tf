variable "private_key_path" {
  description = "RSA private key"
  type        = string
  default     = ""
  validation {
    condition = can(fileexists(var.private_key_path))
    error_message = "The private_key_path must point to a valid file."
  }
}

variable "private_key_passphrase" {
  description = "Passphrase for the RSA private key"
  type        = string
  default     = ""
  sensitive   = true
}

variable "snowflake_username" {
  description = "Snowflake username for RSA key authentication"
  type = string
}

variable "snowflake_role" {
  description = "Snowflake role for the session"
  type = string
}

variable "bucket" {
  type = string
  default = "terraform-remote-state-119610444513"
}

variable "key" {
  type = string
  default = "snowflake_base/snowflake-iac.tfstate"
}

variable "region" {
  type = string
  default = "us-east-1"
}

variable "snowflake_account" {
  type = string
  sensitive = true
  default = "RGARE-APPOC"
}

variable "environment" {
  description = "Current environment"
  type = string
  default = "poc"
}

variable "database_types" {
  description = "List of database types"
  type = list(string)
  default = ["RAW", "CUR", "ACC"]
}

# variable "database_name" {
#   description = "The name of the database."
#   type        = string
# }

variable "account_name" {
  type = string
}

