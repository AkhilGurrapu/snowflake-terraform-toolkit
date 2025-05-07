# variable "name" {
#   description = "The name of the storage integration."
#   type        = string
# }
#
# variable "comment" {
#   description = "A comment for the storage integration."
#   type        = string
#   default     = null
# }
#
# variable "type" {
#   description = "The type of the storage integration (e.g., EXTERNAL_STAGE)."
#   type        = string
# }
#
# variable "enabled" {
#   description = "Whether the storage integration is enabled."
#   type        = bool
# }
#
# variable "storage_allowed_locations" {
#   description = "A list of allowed storage locations for the integration."
#   type        = list(string)
# }
#
# variable "storage_provider" {
#   description = "The storage provider (e.g., S3)."
#   type        = string
# }
#
# variable "aws_external_id" {
#   description = "The AWS external ID for the storage integration."
#   type        = string
# }
#
# variable "aws_iam_user_arn" {
#   description = "The AWS IAM user ARN for the storage integration."
#   type        = string
#   default     = null
# }
#
# variable "aws_role_arn" {
#   description = "The AWS role ARN for the storage integration."
#   type        = string
#   default     = null
# }