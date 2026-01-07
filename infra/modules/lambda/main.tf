resource "aws_lambda_function" "this" {
  function_name = var.function_name
  role          = var.role_arn
  handler       = var.handler
  runtime       = var.runtime

  filename         = var.placeholder_zip
  source_code_hash = filebase64sha256(var.placeholder_zip)

  timeout = 10
  memory_size = 128

  lifecycle {
    ignore_changes = [
      filename,
      source_code_hash
    ]
  }
}
