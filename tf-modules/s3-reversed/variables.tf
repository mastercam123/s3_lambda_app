###########
# S3 Bucket variables to get string and store reversed string
###########
variable "s3_bucket_name" {
  description = "Name of the S3 bucket to get and store the string data"
  type        = string
}
variable "input_prefix" {
  description = "Prefix for the input data in S3 bucket"
  type        = string
}
variable "output_prefix" {
  description = "Prefix for the output data in S3 bucket"
  type        = string
}

###########
# Lambda to reverse string
###########
variable "lambda_function_name" {
  description = "Name of the lambda function to reverse the string data"
  type        = string
  default     = "lambda_reverse_string"
}
variable "lambda_timeout" {
  description = "Timeout for lambda function in seconds"
  type        = number
  default     = 10
}
variable "log_group_retention_period" {
  description = "Retention period in days for lambda log group"
  type        = number
  default     = 90
}
###########
# IAM Role for lambda execution
###########
variable "lambda_role" {
  description = "Name of IAM Role for lambda to gain access to other AWS services"
  type        = string
  default     = "lambda-reverse-role"
}
