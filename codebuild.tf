provider "aws" {
access_key = var.access_key
secret_key = var.secret_key
region = var.region
}

resource "aws_codebuild_project" "examplep" {
  name          = "test-project"
  description   = "test_codebuild_project"
  build_timeout = "5"
  service_role  = aws_iam_role.examplep.arn

  artifacts {
    type = "NO_ARTIFACTS"
  }

  cache {
    type     = "S3"
    location = aws_s3_bucket.examplep.bucket
  }

  environment {
    compute_type                = "BUILD_GENERAL1_SMALL"
    image                       = "aws/codebuild/amazonlinux2-x86_64-standard:3.0"
    type                        = "LINUX_CONTAINER"
    image_pull_credentials_type = "CODEBUILD"



  }

  logs_config {

    s3_logs {
      status   = "ENABLED"
      location = "${aws_s3_bucket.examplep.id}/build-log"
    }
  }

  source {
    type            = "GITHUB"
    location        = "https://github.com/UMuryn/lavagna.git"
    git_clone_depth = 1

    git_submodules_config {
      fetch_submodules = false
    }
  }

  source_version = "master"


  tags = {
    Environment = "Test"
  }
}


resource "aws_s3_bucket" "examplep" {
  bucket = "examplep"
  acl    = "private"
}

resource "aws_iam_role" "examplep" {
  name = "examplep"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "codebuild.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF
}

resource "aws_iam_role_policy" "examplep" {
  role = aws_iam_role.examplep.name

  policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Resource": [
        "*"
      ],
      "Action": [
        "logs:CreateLogGroup",
        "logs:CreateLogStream",
        "logs:PutLogEvents"
      ]
    },
    {
      "Effect": "Allow",
      "Action": [
        "ec2:CreateNetworkInterface",
        "ec2:DescribeDhcpOptions",
        "ec2:DescribeNetworkInterfaces",
        "ec2:DeleteNetworkInterface",
        "ec2:DescribeSubnets",
        "ec2:DescribeSecurityGroups",
        "ec2:DescribeVpcs"
      ],
      "Resource": "*"
    },
    {
      "Effect": "Allow",
      "Action": [
        "ec2:CreateNetworkInterfacePermission"
      ],
      "Resource": [
        "arn:aws:ec2:us-east-1:123456789012:network-interface/*"
      ]
    },
    {
      "Effect": "Allow",
      "Action": [
        "s3:*"
      ],
      "Resource": [
        "${aws_s3_bucket.examplep.arn}",
        "${aws_s3_bucket.examplep.arn}/*"
      ]
    }
  ]
}
POLICY
}

