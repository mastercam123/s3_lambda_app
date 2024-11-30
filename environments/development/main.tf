locals {
  s3_bucket_name_state_file = join("-", [var.env_prefix, var.s3_task_bucket_name])
}

#######################################################################
# Create the required resources for the tasks
#######################################################################
## Create S3 bucket for the data
resource "aws_s3_bucket" "string_bucket" {
  bucket = local.s3_bucket_name_state_file
}

## Call module to create lambda function for reversed string
module "name_prefix_filter" {
  source         = "../../tf-modules/s3-reversed"
  s3_bucket_name = local.s3_bucket_name_state_file
  input_prefix   = var.input_prefix_filter
  output_prefix  = var.output_prefix_filter
  env_prefix     = var.env_prefix
}
## Create S3 Bucket notification for the lambda function
resource "aws_s3_bucket_notification" "object_put_notification" {
  bucket = aws_s3_bucket.string_bucket.id

  lambda_function {
    lambda_function_arn = module.name_prefix_filter.lambda_function_arn
    events              = ["s3:ObjectCreated:*"]
    filter_prefix       = var.input_prefix_filter
  }

  depends_on = [module.name_prefix_filter]
}

resource "aws_s3_bucket" "test_dev_bucket" {
  bucket = "test-dev1-bucket-husain-2024"
}
