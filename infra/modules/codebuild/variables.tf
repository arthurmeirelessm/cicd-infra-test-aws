variable "build_project_name" {}
variable "service_role_arn" {}

variable "aws_region" {}
variable "aws_account_id" {}

variable "buildspec_path" {}

# Backend-only
variable "lambda_name" {
  default = null
}

variable "layer_name" {
  default = null
}

variable "layer_bucket" {
  default = null
}
