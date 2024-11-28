output "lambda_function_arn" {
  value       = aws_lambda_function.rewrite_lambda_function.arn
  description = "ARN of the lambda function to reverse the string data"
}
