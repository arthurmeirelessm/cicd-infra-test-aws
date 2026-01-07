# PROVIDER
provider "aws" {
  region = var.aws_region
}

# IAM LAMBDA
module "iam_lambda" {
  source = "../modules/iam"

  role_name = "lambda-execution-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect = "Allow"
      Principal = {
        Service = "lambda.amazonaws.com"
      }
      Action = "sts:AssumeRole"
    }]
  })

  inline_policies = {
    lambda-basic-policy = jsonencode({
      Version = "2012-10-17"
      Statement = [
        {
          Effect = "Allow"
          Action = [
            "logs:CreateLogGroup",
            "logs:CreateLogStream",
            "logs:PutLogEvents"
          ]
          Resource = "*"
        }
      ]
    })
  }
}

# LAMBDA
module "hello_lambda" {
  source = "../modules/lambda"

  function_name   = "hello-world"
  runtime         = "python3.11"
  handler         = "handler.handler"
  role_arn        = module.iam_lambda.role_arn
  placeholder_zip = "${path.module}/../placeholder.zip"
}


module "second_test_lambda" {
  source = "../modules/lambda"

  function_name   = "second-test-lambda"
  runtime         = "python3.11"
  handler         = "handler.handler"
  role_arn        = module.iam_lambda.role_arn
  placeholder_zip = "${path.module}/../placeholder.zip"
}