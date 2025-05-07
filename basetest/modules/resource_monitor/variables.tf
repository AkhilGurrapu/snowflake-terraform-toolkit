variable "resource_monitor_name" {
  description = "Name of the resource monitor"
  type        = string
}

variable "credit_quota" {
  description = "Credit quota allocated to the resource monitor"
  type        = number
  default     = null
}

variable "frequency" {
  description = "Frequency interval for credit usage reset"
  type        = string
  default     = null
}

variable "start_timestamp" {
  description = "Start timestamp for the resource monitor"
  type        = string
  default     = null
}

variable "end_timestamp" {
  description = "End timestamp for the resource monitor"
  type        = string
  default     = null
}

variable "notify_triggers" {
  description = "List of percentages of the credit quota for notifications"
  type        = list(number)
  default     = []
}

variable "suspend_trigger" {
  description = "Percentage of credit quota to suspend assigned warehouses"
  type        = number
  default     = null
}

variable "suspend_immediate_trigger" {
  description = "Percentage of credit quota to immediately suspend assigned warehouses"
  type        = number
  default     = null
}

variable "notify_users" {
  description = "List of users to receive notifications"
  type        = list(string)
  default     = []
}

