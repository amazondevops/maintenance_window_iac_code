variable "name" {
  description = "Name of the SSM Window"
  type        = string
  default     = "SSM-Prod-Maintainance-Window"
}

variable "schedule" {
  description = "Cron job Schedule"
  type        = string
  default     = "cron(0 */1 * * * ? *)"
}

variable "maintenance_window_duration" {
  description = "The duration of the maintenence windows (hours)"
  type        = number
  default     = 3
}

variable "maintenance_window_cutoff" {
  description = "The number of hours before the end of the Maintenance Window that Systems Manager stops scheduling new tasks for execution"
  type        = number
  default     = 1
}

variable "max_concurrency" {
  description = "The maximum amount of concurrent instances of a task that will be executed in parallel"
  type        = number
  default     = 25
}

variable "max_errors" {
  description = "The maximum amount of errors that instances of a task will tollerate before being de-scheduled"
  type        = number
  default     = 50
}

variable "s3_bucket_name" {
  description = "The s3 bucket name where to store logs when patch are applied"
  type        = string
  default     = "aw2-patching-logs"
}

variable "service_role_arn" {
  description = "The sevice role ARN to attach to the Maintenance windows"
  type        = string
  default     = "arn:aws:iam::980783347387:role/maintanance_window_patch_group_role"
}

variable "s3_bucket_prefix_install_logs" {
  description = "The sevice role ARN to attach to the Maintenance windows"
  type        = string
  default     = "Install"
}
variable "task_install_priority" {
  description = "Priority assigned to the install task. 1 is the highest priority. Default 1"
  type        = number
  default     = 1
}
variable "reboot_option" {
  description = "Parameter 'Reboot Option' to pass to the windows Task Execution. By Default : 'RebootIfNeeded'. Possible values : RebootIfNeeded, NoReboot"
  type        = bool
  default     = true # True or False
}
variable "operation_type" {
  description = "Parameter 'Reboot Option' to pass to the windows Task Execution. By Default : 'RebootIfNeeded'. Possible values : RebootIfNeeded, NoReboot"
  type        = string
  default     = "Install" # Choose the action Install or Scan
}


variable "window_target" {
  description = "This variable is used to specify the target instances for the Maintenance window - PatchGroup"
  type        = map(any)
  default = {
    key    = "tag:PatchGroup"
    values = "WinUpdate"
  }
}
