resource "aws_iam_role" "codebuild_role" {
  name = "terraform-employee-api-codebuild-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Service = "codebuild.amazonaws.com"
        }
        Action = "sts:AssumeRole"
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "codebuild_admin" {
  role       = aws_iam_role.codebuild_role.name
  policy_arn = "arn:aws:iam::aws:policy/AdministratorAccess"
}

resource "aws_codebuild_project" "terraform_deploy" {
  name           = "terraform-employee-api-build"
  description    = "Runs Terraform init/plan/apply for Employee API"
  service_role   = aws_iam_role.codebuild_role.arn
  source_version = "branch1"

  artifacts {
    type = "NO_ARTIFACTS"
  }

  environment {
    compute_type = "BUILD_GENERAL1_SMALL"
    image        = "aws/codebuild/amazonlinux-x86_64-standard:5.0"
    type         = "LINUX_CONTAINER"
  }

  source {
    type      = "GITHUB"
    location  = "https://github.com/thelonehunter-1/terraform-employee-api.git"
    buildspec = "buildspec.yml"
  }
}
