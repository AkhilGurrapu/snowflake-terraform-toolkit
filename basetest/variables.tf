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

variable "account_name" {
  type = string
}

variable "storage_integration_name" {
  description = "The name of the storage integration."
  type        = string
}

variable "storage_integration_comment" {
  description = "A comment for the storage integration."
  type        = string
}

variable "storage_integration_type" {
  description = "The type of the storage integration (e.g., EXTERNAL_STAGE)."
  type        = string
}

variable "storage_integration_provider" {
  description = "The storage provider for the integration (e.g., S3)."
  type        = string
}

variable "storage_integration_arn" {
  description = "The AWS IAM role ARN for the storage integration."
  type        = string
}

variable "storage_integration_external_id" {
  description = "The AWS external ID for the storage integration."
  type        = string
}

variable "storage_integration_enabled" {
  description = "Whether the storage integration is enabled."
  type        = bool
}

variable "storage_integration_allowed_locations" {
  description = "A list of allowed storage locations for the storage integration."
  type        = list(string)
}
