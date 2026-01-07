variable "aws_region" {
    default = "us-east-1"
}
variable "aws_account_id" {
    default = "552516487395"
}
variable "github_owner" {
    default = "arthurmeirelessm"
}

variable "codestar_connection_arn" {
    default = "arn:aws:codeconnections:us-east-1:552516487395:connection/51441b53-56a4-441e-9fce-d3667adaa545"
}

variable "backend_repository_name" {
    default = "cicd-backend-test-aws"
}
variable "backend_branch" {
  default = "main"
}

variable "infra_repository_name" {
    default = "cicd-infra-test-aws"
}
variable "infra_branch" {
  default = "main"
}
