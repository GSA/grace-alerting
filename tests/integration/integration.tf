resource "aws_cloudwatch_log_group" "integration_test" {
  name = "integration_test"
}

module "integration_test" {
  source                    = "../../"
  recipient                 = "a@b.c"
  cloudtrail_log_group_name = aws_cloudwatch_log_group.integration_test.name
}
