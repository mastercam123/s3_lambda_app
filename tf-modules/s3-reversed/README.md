<!-- BEGIN_TF_DOCS -->

## Requirements

| Name                                                                     | Version  |
| ------------------------------------------------------------------------ | -------- |
| <a name="requirement_terraform"></a> [terraform](#requirement_terraform) | >= 1.7.1 |
| <a name="requirement_aws"></a> [aws](#requirement_aws)                   | >= 5.0   |

## Providers

| Name                                             | Version |
| ------------------------------------------------ | ------- |
| <a name="provider_aws"></a> [aws](#provider_aws) | >= 5.0  |

## Modules

No modules.

## Resources

| Name                                                                                                                                                     | Type        |
| -------------------------------------------------------------------------------------------------------------------------------------------------------- | ----------- |
| [aws_cloudwatch_log_group.lambda_log_group_reverse](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_log_group)    | resource    |
| [aws_iam_role.lambda_reverse_role](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role)                                 | resource    |
| [aws_lambda_function.rewrite_lambda_function](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lambda_function)               | resource    |
| [aws_lambda_permission.allow_bucket](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lambda_permission)                      | resource    |
| [archive_file.lambda_reverse_function](https://registry.terraform.io/providers/hashicorp/archive/latest/docs/data-sources/file)                          | data source |
| [aws_caller_identity.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/caller_identity)                            | data source |
| [aws_iam_policy_document.lambda_reverse_role_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_region.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/region)                                              | data source |

## Inputs

| Name                                                                                                            | Description                                                      | Type     | Default                   | Required |
| --------------------------------------------------------------------------------------------------------------- | ---------------------------------------------------------------- | -------- | ------------------------- | :------: |
| <a name="input_input_prefix"></a> [input_prefix](#input_input_prefix)                                           | Prefix for the input data in S3 bucket                           | `string` | n/a                       |   yes    |
| <a name="input_lambda_function_name"></a> [lambda_function_name](#input_lambda_function_name)                   | Name of the lambda function to reverse the string data           | `string` | `"lambda_reverse_string"` |    no    |
| <a name="input_lambda_role"></a> [lambda_role](#input_lambda_role)                                              | Name of IAM Role for lambda to gain access to other AWS services | `string` | `"lambda-reverse-role"`   |    no    |
| <a name="input_lambda_timeout"></a> [lambda_timeout](#input_lambda_timeout)                                     | Timeout for lambda function in seconds                           | `number` | `10`                      |    no    |
| <a name="input_log_group_retention_period"></a> [log_group_retention_period](#input_log_group_retention_period) | Retention period in days for lambda log group                    | `number` | `90`                      |    no    |
| <a name="input_output_prefix"></a> [output_prefix](#input_output_prefix)                                        | Prefix for the output data in S3 bucket                          | `string` | n/a                       |   yes    |
| <a name="input_s3_bucket_name"></a> [s3_bucket_name](#input_s3_bucket_name)                                     | Name of the S3 bucket to get and store the string data           | `string` | n/a                       |   yes    |

## Outputs

| Name                                                                                         | Description                                           |
| -------------------------------------------------------------------------------------------- | ----------------------------------------------------- |
| <a name="output_lambda_function_arn"></a> [lambda_function_arn](#output_lambda_function_arn) | ARN of the lambda function to reverse the string data |

<!-- END_TF_DOCS -->
