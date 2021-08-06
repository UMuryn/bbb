provider "aws" {
access_key = var.access_key
secret_key = var.secret_key
region = var.region
}


resource "aws_elastic_beanstalk_application" "tftest" {
  name        = "a"
  description = "a-env"
}



resource "aws_elastic_beanstalk_environment" "app" {
  name = "app-task-env"
  application = "app-task"
  solution_stack_name = "64bit Amazon Linux 2 v4.1.3 running Tomcat 8.5 Corretto 8"
  cname_prefix = "ovo-microservice-example-uat-app"
  setting {
    namespace = "aws:autoscaling:launchconfiguration"
    name = "IamInstanceProfile"
    value = "aws-elasticbeanstalk-ec2-role"
  }
  setting {
    namespace = "aws:ec2:vpc"
    name = "VPCId"
    value = "vpc-0f464edcac67af457"
  }
  setting {
    namespace = "aws:ec2:vpc"
    name = "AssociatePublicIpAddress"
    value = "true"
  }
  setting {
    namespace = "aws:ec2:vpc"
    name = "Subnets"
    value = "subnet-0732e5e4232bb40a8,subnet-04bb063b5540c0c9c,subnet-014ece523ed395437"
  }
  setting {
    namespace = "aws:ec2:vpc"
    name = "ELBSubnets"
    value = "subnet-0732e5e4232bb40a8,subnet-04bb063b5540c0c9c,subnet-014ece523ed395437"
  }
  setting {
    namespace = "aws:ec2:vpc"
    name = "ELBScheme"
    value = "internal"
  }
  setting {
    namespace = "aws:autoscaling:launchconfiguration"
    name = "InstanceType"
    value = "t2.micro"
  }
  setting {
    namespace = "aws:autoscaling:asg"
    name = "Availability Zones"
    value = "Any 2"
  }
  setting {
    namespace = "aws:autoscaling:asg"
    name = "MinSize"
    value = "2"
  }
  setting {
    namespace = "aws:autoscaling:asg"
    name = "MaxSize"
    value = "3"
  }
  setting {
    namespace = "aws:elasticbeanstalk:environment"
    name = "ServiceRole"
    value = "aws-elasticbeanstalk-service-role"
  }
  setting {
    namespace = "aws:elasticbeanstalk:application:environment"
    name = "environment"
    value = "uat"
  }
  setting {
    namespace = "aws:elasticbeanstalk:application:environment"
    name = "LOGGING_APPENDER"
    value = "GRAYLOG"
  }
  setting {
    namespace = "aws:elasticbeanstalk:healthreporting:system"
    name = "SystemType"
    value = "enhanced"
  }
  setting {
    namespace = "aws:autoscaling:updatepolicy:rollingupdate"
    name = "RollingUpdateEnabled"
    value = "true"
  }
  setting {
    namespace = "aws:autoscaling:updatepolicy:rollingupdate"
    name = "RollingUpdateType"
    value = "Health"
  }
  setting {
    namespace = "aws:autoscaling:updatepolicy:rollingupdate"
    name = "MinInstancesInService"
    value = "2"
  }
  setting {
    namespace = "aws:autoscaling:updatepolicy:rollingupdate"
    name = "MaxBatchSize"
    value = "1"
  }
  setting {
    namespace = "aws:elasticbeanstalk:command"
    name = "BatchSizeType"
    value = "Fixed"
  }
  setting {
    namespace = "aws:elasticbeanstalk:command"
    name = "BatchSize"
    value = "1"
  }
  setting {
    namespace = "aws:elasticbeanstalk:command"
    name = "DeploymentPolicy"
    value = "Rolling"
  }
  setting {
    namespace = "aws:elb:policies"
    name = "ConnectionDrainingEnabled"
    value = "true"
  }
  setting {
    namespace = "aws:autoscaling:launchconfiguration"
    name = "SecurityGroups"
    value = "sg-021ca09f1a6afdb3a"
  }

}
