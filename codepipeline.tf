provider "aws" {
access_key = var.access_key
secret_key = var.secret_key
region = var.region
version = "~> 2.16"
}
resource "aws_codepipeline" "codepipeline" {
  name     = "tf-test-pipeline"
  role_arn = aws_iam_role.codepipeline_role.arn

  artifact_store {
    location = aws_s3_bucket.codepipeline_bucket.bucket
    type     = "S3"

  }

  stage {
    name = "Source"

    action {
      name             = "Source"
      category         = "Source"
      owner            = "ThirdParty"
      provider         = "GitHub"
      version          = "1"
      output_artifacts = ["source_output"]

      configuration = {
        Owner      = "UMuryn"
        Repo       = "lavagna"
        Branch     = "master"
        OAuthToken = var.OAuthToken
      }
    }
  }

  stage {
    name = "Build"

    action {
      name             = "Build"
      category         = "Build"
      owner            = "AWS"
      provider         = "CodeBuild"
      input_artifacts  = ["source_output"]
      output_artifacts = ["build_output"]
      version          = "1"
	  
      configuration = {
        ProjectName = "test-project"
      }
    }
  }

  
  stage {
    name = "Deploy"

    action {
      name = "Deploy"
      category = "Deploy"
      owner = "AWS"
      provider = "ElasticBeanstalk"
      input_artifacts = ["build_output"]
      version = "1"

      configuration = {
        ApplicationName = "a"
        EnvironmentName = "a-env"
      }
    }
  }


}
resource "aws_s3_bucket" "codepipeline_bucket" {
  bucket = "lavagnamy-bucket"
  acl    = "public-read-write"
}

resource "aws_iam_role" "codepipeline_role" {
  name = "lavagnamy-role"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "codepipeline.amazonaws.com"
      },
      "Action": ["compute-optimizer:GetEnrollmentStatus","sts:AssumeRole"]
    },
	    {
      "Effect": "Allow",
      "Principal": {
        "Service": "elasticbeanstalk.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF
}

resource "aws_iam_role_policy" "codepipeline_policy" {
  name = "codepipeline_policy"
  role = aws_iam_role.codepipeline_role.id

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect":"Allow",
      "Action": ["compute-optimizer:GetEnrollmentStatus","s3:*"],
      "Resource": "*"
    },
    {
      "Effect": "Allow",
      "Action": ["compute-optimizer:GetEnrollmentStatus","codebuild:*"],
      "Resource": "*"
    },
	{
            "Action": [
"compute-optimizer:GetEnrollmentStatus",
                "s3:PutObject"
            ],
            "Resource": [
                "arn:aws:s3:::codepipeline*",
                "arn:aws:s3:::elasticbeanstalk*"
            ],
            "Effect": "Allow"
        },
        {
            "Action": [
"compute-optimizer:GetEnrollmentStatus",
                "lambda:invokefunction",
                "lambda:listfunctions"
            ],
            "Resource": "*",
            "Effect": "Allow"
        },
		{
            "Action": [
"compute-optimizer:GetEnrollmentStatus",
                "s3:PutObject"
            ],
            "Resource": [
                "arn:aws:s3:::codepipeline*",
                "arn:aws:s3:::elasticbeanstalk*"
            ],
            "Effect": "Allow"
        },
        {
            "Action": [
"compute-optimizer:GetEnrollmentStatus",
                "codedeploy:CreateDeployment",
                "codedeploy:GetApplicationRevision",
                "codedeploy:GetDeployment",
                "codedeploy:GetDeploymentConfig",
                "codedeploy:RegisterApplicationRevision"
            ],
            "Resource": "*",
            "Effect": "Allow"
        },
        {
            "Action": [
"compute-optimizer:GetEnrollmentStatus",
                "elasticbeanstalk:CreateApplicationVersion",
                "elasticbeanstalk:DescribeApplicationVersions",
                "elasticbeanstalk:DescribeEnvironments",
                "elasticbeanstalk:DescribeEvents",
                "elasticbeanstalk:UpdateEnvironment",
                "autoscaling:DescribeAutoScalingGroups",
                "autoscaling:DescribeLaunchConfigurations",
                "autoscaling:DescribeScalingActivities",
                "autoscaling:ResumeProcesses",
                "autoscaling:SuspendProcesses",
                "cloudformation:GetTemplate",
                "cloudformation:DescribeStackResource",
                "cloudformation:DescribeStackResources",
                "cloudformation:DescribeStackEvents",
                "cloudformation:DescribeStacks",
                "cloudformation:UpdateStack",
                "ec2:DescribeInstances",
                "ec2:DescribeImages",
                "ec2:DescribeAddresses",
                "ec2:DescribeSubnets",
                "ec2:DescribeVpcs",
                "ec2:DescribeSecurityGroups",
                "ec2:DescribeKeyPairs",
                "elasticloadbalancing:DescribeLoadBalancers",
                "rds:DescribeDBInstances",
                "rds:DescribeOrderableDBInstanceOptions",
                "sns:ListSubscriptionsByTopic"
            ],
            "Resource": "*",
            "Effect": "Allow"
        },
        {
            "Action": [
"compute-optimizer:GetEnrollmentStatus",
                "lambda:invokefunction",
                "lambda:listfunctions"
            ],
            "Resource": "*",
            "Effect": "Allow"
        },
        {
            "Action": [
"compute-optimizer:GetEnrollmentStatus",
                "s3:ListBucket",
                "s3:GetBucketPolicy",
                "s3:GetObjectAcl",
                "s3:PutObjectAcl",
                "s3:DeleteObject"
            ],
            "Resource": "arn:aws:s3:::elasticbeanstalk*",
            "Effect": "Allow"
        }

  ]
}
EOF
}
