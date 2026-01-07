resource "aws_codebuild_project" "this" {
  name         = var.build_project_name
  service_role = var.service_role_arn

  artifacts {
    type = "CODEPIPELINE"
  }

  environment {
    compute_type = "BUILD_GENERAL1_SMALL"
    image        = "aws/codebuild/standard:6.0"
    type         = "LINUX_CONTAINER"

    environment_variable {
      name  = "AWS_REGION"
      value = var.aws_region
    }

    environment_variable {
      name  = "AWS_ACCOUNT_ID"
      value = var.aws_account_id
    }

    # Usado apenas no pipeline de backend
    dynamic "environment_variable" {
      for_each = var.lambda_name != null ? [1] : []
      content {
        name  = "LAMBDA_FUNCTION_NAME"
        value = var.lambda_name
      }
    }

    dynamic "environment_variable" {
      for_each = var.layer_name != null ? [1] : []
      content {
        name  = "LAYER_NAME"
        value = var.layer_name
      }
    }

    dynamic "environment_variable" {
      for_each = var.layer_bucket != null ? [1] : []
      content {
        name  = "LAYER_BUCKET"
        value = var.layer_bucket
      }
    }
  }

  source {
    type      = "CODEPIPELINE"
    buildspec = var.buildspec_path
  }
}
