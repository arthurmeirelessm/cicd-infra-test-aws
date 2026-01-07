# PROVIDER
provider "aws" {
  region = var.aws_region
}

# ARTIFACT BUCKET
resource "aws_s3_bucket" "artifacts" {
  bucket = "cicd-artifacts-${var.aws_account_id}-test"
}

# IAM ROLES PARA CI/CD
module "iam_codepipeline" {
  source = "../modules/iam"

  role_name = "codepipeline-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect = "Allow"
      Principal = {
        Service = "codepipeline.amazonaws.com"
      }
      Action = "sts:AssumeRole"
    }]
  })

  inline_policies = {
    codepipeline-policy = jsonencode({
      Version = "2012-10-17"
      Statement = [
        {
          Effect = "Allow"
          Action = [
            "s3:GetObject",
            "s3:GetObjectVersion",
            "s3:PutObject"
          ]
          Resource = [
            "arn:aws:s3:::cicd-artifacts-${var.aws_account_id}-test",
            "arn:aws:s3:::cicd-artifacts-${var.aws_account_id}-test/*"
          ]
        },
        {
          Effect = "Allow"
          Action = ["s3:ListBucket"]
          Resource = "arn:aws:s3:::cicd-artifacts-${var.aws_account_id}-test"
        },
        {
          Effect = "Allow"
          Action = [
            "codebuild:StartBuild",
            "codebuild:BatchGetBuilds"
          ]
          Resource = "*"
        },
        {
          Effect = "Allow"
          Action = "codestar-connections:UseConnection"
          Resource = "*"
        },
        {
          Effect = "Allow"
          Action = "iam:PassRole"
          Resource = "*"
        }
      ]
    })
  }
}

module "iam_codebuild" {
  source = "../modules/iam"

  role_name = "codebuild-cicd-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect = "Allow"
      Principal = {
        Service = "codebuild.amazonaws.com"
      }
      Action = "sts:AssumeRole"
    }]
  })

  inline_policies = {
    codebuild-policy = jsonencode({
      Version = "2012-10-17"
      Statement = [
        {
          Effect = "Allow"
          Action = [
            "iam:*",           # Permite criar roles da aplicação
            "lambda:*",
            "s3:*",
            "logs:*",
            "apigateway:*",
            "dynamodb:*"
          ]
          Resource = "*"
        }
      ]
    })
  }
}

# CODEBUILD – BACKEND
module "codebuild_backend" {
  source = "../modules/codebuild"

  build_project_name = "backend-build"
  service_role_arn   = module.iam_codebuild.role_arn

  aws_region     = var.aws_region
  aws_account_id = var.aws_account_id

  buildspec_path = "backend/buildspec_backend.yml"
}

# CODEPIPELINE – BACKEND
module "backend_pipeline" {
  source = "../modules/pipeline"

  pipeline_name     = "backend-pipeline"
  pipeline_role_arn = module.iam_codepipeline.role_arn
  artifact_bucket   = aws_s3_bucket.artifacts.bucket

  codestar_connection_arn = var.codestar_connection_arn
  github_owner            = var.github_owner
  repository_name         = var.backend_repository_name
  branch_name             = var.backend_branch

  codebuild_project_name = module.codebuild_backend.name
}

# CODEBUILD – INFRA
module "codebuild_infra" {
  source = "../modules/codebuild"

  build_project_name = "infra-build"
  service_role_arn   = module.iam_codebuild.role_arn

  aws_region     = var.aws_region
  aws_account_id = var.aws_account_id

  buildspec_path = "infra/templates/buildspec_infra.yml"
}

# CODEPIPELINE – INFRA
module "infra_pipeline" {
  source = "../modules/pipeline"

  pipeline_name     = "infra-pipeline"
  pipeline_role_arn = module.iam_codepipeline.role_arn
  artifact_bucket   = aws_s3_bucket.artifacts.bucket

  codestar_connection_arn = var.codestar_connection_arn
  github_owner            = var.github_owner
  repository_name         = var.infra_repository_name
  branch_name             = var.infra_branch

  codebuild_project_name = module.codebuild_infra.name
}