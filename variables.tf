variable "url_github_oidc" {
  description = "The URL of the GitHub OIDC provider"
  type        = string
  default     = "https://token.actions.githubusercontent.com"
}
variable "S3_bucket_name_state_file" {
  description = "The name of the S3 bucket for the Terraform state file"
  type        = string
  default     = "hsn-oidc-test-2024"

}
variable "GitHub_Organization" {
  description = "The GitHub Organization"
  type        = string
  default     = "mastercam123"
}
variable "GitHub_Repository" {
  description = "The GitHub Repository"
  type        = string
  default     = "s3_lambda_app"

}

variable "Repository_dev_branch" {
  description = "The GitHub Repository for development branch"
  type        = string
  default     = "dev"
}
variable "Repository_prod_branch" {
  description = "The GitHub Repository for production branch"
  type        = string
  default     = "main"
}
variable "github_action_role_name" {
  description = "The name of the IAM role for GitHub Actions"
  type        = string
  default     = "github_action_role"
}
