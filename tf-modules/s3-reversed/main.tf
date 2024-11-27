data "aws_region" "current" {}
data "aws_caller_identity" "current" {}

###########
# Lambda to read, reverse and put data back to S3 bucket
###########
#### Lambda log group
resource "aws_cloudwatch_log_group" "lambda_log_group_reverse" {
  name              = "/aws/lambda/${var.lambda_function_name}"
  retention_in_days = var.log_group_retention_period
}
#### Lambda resource
data "archive_file" "lambda_reverse_function" {
  type        = "zip"
  source_file = "${path.module}/src/string_reverse.py"
  output_path = "${path.module}/src/string_reverse_function.zip"
}

resource "aws_lambda_function" "rewrite_lambda_function" {
  function_name    = var.lambda_function_name
  role             = aws_iam_role.lambda_reverse_role.arn
  filename         = "${path.module}/src/backup-fail-resources.zip"
  runtime          = "python3.11"
  source_code_hash = data.archive_file.lambda_reverse_function.output_base64sha256
  handler          = "string_reverse.lambda_handler"
  timeout          = var.lambda_timeout

  environment {
    variables = {
      bucket_name   = "${var.s3_bucket_name}",
      input_prefix  = "${var.input_prefix}",
      output_prefix = "${var.output_prefix}"
    }
  }
  depends_on = [aws_cloudwatch_log_group.lambda_log_group_reverse]
}

#### IAM Role for lambda execution
resource "aws_iam_role" "lambda_reverse_role" {
  name               = var.lambda_role
  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "lambda.amazonaws.com"
      },
      "Effect": "Allow"
    }
  ]
}
EOF
  inline_policy {
    name   = "lambda-policy"
    policy = data.aws_iam_policy_document.lambda_reverse_role_policy.json
  }
}
data "aws_iam_policy_document" "lambda_reverse_role_policy" {
  statement {
    sid    = "1"
    effect = "Allow"
    actions = [
      "logs:CreateLogGroup"
    ]
    resources = ["arn:aws:logs:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:*"]
  }
  statement {
    sid    = "2"
    effect = "Allow"
    actions = [
      "logs:CreateLogStream",
      "logs:PutLogEvents"
    ]
    resources = ["${aws_cloudwatch_log_group.lambda_log_group_reverse.arn}:*"]
  }
  statement {
    sid    = "3"
    effect = "Allow"
    actions = [
      "s3:GetObject",
      "s3:PutObject",
      "s3:ListBucket"
    ]
    resources = ["arn:aws:s3:::${var.s3_bucket_name}"]
  }
  statement {
    sid    = "4"
    effect = "Allow"
    actions = [
      "s3:GetObject",
      "s3:PutObject"
    ]
    resources = ["arn:aws:s3:::${var.s3_bucket_name}/${var.input_prefix}/", "arn:aws:s3:::${var.s3_bucket_name}/${var.output_prefix}/"]
  }
}
