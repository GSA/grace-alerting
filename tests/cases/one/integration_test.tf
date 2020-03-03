terraform {
  backend "local" {
    path = "terraform.tfstate"
  }
}

provider "aws" {
  region = "us-east-1"
  endpoints {
    sns              = "http://localhost:5000"
    cloudformation   = "http://localhost:5000"
    cloudwatchlogs   = "http://localhost:5000"
    cloudwatchevents = "http://localhost:5000"
    sts              = "http://localhost:5000"
  }
}

resource "aws_cloudwatch_log_group" "integration_test" {
  name = "integration_test"
}

module "integration_test" {
  source                    = "../../../"
  recipient                 = "a@b.c"
  cloudtrail_log_group_name = aws_cloudwatch_log_group.integration_test.name
}
