locals {
  string_development_branch = join("", ["repo:", var.GitHub_Organization, "/", var.GitHub_Repository, ":ref:refs/heads", var.Repository_dev_branch, "*"])
  string_production_branch  = join("", ["repo:", var.GitHub_Organization, "/", var.GitHub_Repository, ":ref:refs/heads", var.Repository_prod_branch, "*"])
  string_tag                = join("", ["repo:", var.GitHub_Organization, "/", var.GitHub_Repository, ":ref:refs/tags/v*"])
}

###########
# Create the required resources for the GitHub Actions to assume the IAM role
###########
## Create the OIDC provider 
resource "aws_iam_openid_connect_provider" "github_action" {
  url             = var.url_github_oidc
  client_id_list  = ["sts.amazonaws.com"]
  thumbprint_list = ["ffffffffffffffffffffffffffffffffffffffff"] # thumbprint of the OIDC provider is not used anymore but still required (suggested from GitHub)
}

## Create the IAM policy document and the IAM role

data "aws_iam_policy_document" "assume_role_oidc_policy" {
  statement {
    actions = ["sts:AssumeRoleWithWebIdentity"]
    effect  = "Allow"

    principals {
      type        = "Federated"
      identifiers = [aws_iam_openid_connect_provider.github_action.arn]
    }

    condition {
      test     = "StringEquals"
      values   = ["sts.amazonaws.com"]
      variable = "token.actions.githubusercontent.com:aud"
    }

    condition {
      test     = "StringLike"
      variable = "${aws_iam_openid_connect_provider.github_action.url}:sub"
      values = [
        local.string_development_branch,
        local.string_production_branch,
        local.string_tag
      ]
    }
  }
}

resource "aws_iam_role" "github_action_role" {
  name               = var.github_action_role_name
  assume_role_policy = data.aws_iam_policy_document.assume_role_oidc_policy.json
}

## Fetch AWS Managed policy attach it to the role
data "aws_iam_policy" "S3_full_access" {
  name = "AmazonS3FullAccess"
}
resource "aws_iam_role_policy_attachment" "attach_s3_policy" {
  policy_arn = data.aws_iam_policy.S3_full_access.arn
  role       = aws_iam_role.github_action_role.name
}
## Add additional policy that only allows access to the bucket where terraform state file lies
resource "aws_iam_policy" "deny_outside_tf_bucket" {
  name        = "DenyOutsideTFStateBucket"
  description = "Deny full access actions outside the S3 bucket for terraform state file"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Deny"
        Action = "s3:*"
        Resource = [
          "arn:aws:s3:::*",
          "arn:aws:s3:::*/*"
        ]
        Condition = {
          StringNotEquals = {
            "s3:prefix" = var.S3_bucket_name_state_file
          }
        }
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "attach_deny_outside_test_bucket_policy" {
  policy_arn = aws_iam_policy.deny_outside_tf_bucket.arn
  role       = aws_iam_role.github_action_role.name
}

###########
# Create the required resources for the tasks
###########
