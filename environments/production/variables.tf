variable "env_prefix" {
  description = "The prefix for the environment"
  type        = string
}

##################################
# Variable for the S3 bucket for the task
variable "s3_task_bucket_name" {
  description = "value of the S3 bucket for the task"
  type        = string
  default     = "s3-task-bucket-husain-2024"
}
variable "input_prefix_filter" {
  description = "input prefix for the task"
  type        = string
  default     = "original/"
  validation {
    condition     = can(regex("/$", var.input_prefix_filter))
    error_message = "The prefix must end with '/'"
  }
}
variable "output_prefix_filter" {
  description = "output prefix for the task"
  type        = string
  default     = "reversed/"
  validation {
    condition     = can(regex("/$", var.output_prefix_filter))
    error_message = "The prefix must end with '/'"
  }
}
