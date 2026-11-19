terraform {
  required_version = ">= 1.10"

  backend "s3" {
    bucket       = "glowtail-tfstate-988787367176"
    key          = "cloud-resume/terraform.tfstate"
    region       = "us-east-1"
    use_lockfile = true
    encrypt      = true
  }

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.0"
    }
  }
}

provider "aws" {
  region = "us-east-1"
}

data "aws_caller_identity" "current" {}

# Same GitHub trust setup Glowtail uses
data "aws_iam_openid_connect_provider" "github" {
  url = "https://token.actions.githubusercontent.com"
}

# Guest list: only the main branch of the resume repo
data "aws_iam_policy_document" "deploy_trust" {
  statement {
    actions = ["sts:AssumeRoleWithWebIdentity"]

    principals {
      type        = "Federated"
      identifiers = [data.aws_iam_openid_connect_provider.github.arn]
    }

    condition {
      test     = "StringEquals"
      variable = "token.actions.githubusercontent.com:aud"
      values   = ["sts.amazonaws.com"]
    }

    condition {
      test     = "StringEquals"
      variable = "token.actions.githubusercontent.com:sub"
      values   = ["repo:jessicaparadise/cloud-resume-jp:ref:refs/heads/main"]
    }
  }
}

# Exactly what a deploy needs, nothing more
data "aws_iam_policy_document" "deploy_permissions" {
  statement {
    actions   = ["s3:ListBucket"]
    resources = ["arn:aws:s3:::jessicaparadise.com"]
  }

  statement {
    actions   = ["s3:PutObject", "s3:DeleteObject"]
    resources = ["arn:aws:s3:::jessicaparadise.com/*"]
  }

  statement {
    actions   = ["cloudfront:CreateInvalidation"]
    resources = ["arn:aws:cloudfront::${data.aws_caller_identity.current.account_id}:distribution/E10G2LJT15ZAYN"]
  }
}

resource "aws_iam_role" "deploy" {
  name               = "cloud-resume-github-deploy"
  assume_role_policy = data.aws_iam_policy_document.deploy_trust.json
}

resource "aws_iam_role_policy" "deploy" {
  name   = "deploy-site"
  role   = aws_iam_role.deploy.id
  policy = data.aws_iam_policy_document.deploy_permissions.json
}

output "deploy_role_arn" {
  value = aws_iam_role.deploy.arn
}