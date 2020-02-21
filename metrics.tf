#######################
# Metric based alarms #
#######################


# Metric root_login
resource "aws_cloudwatch_log_metric_filter" "root_login" {
  count          = var.alert_on_root_login ? 1 : 0
  name           = "root_login"
  pattern        = "{ $.userIdentity.type = \"Root\" && $.userIdentity.invokedBy NOT EXISTS && $.eventType != \"AwsServiceEvent\" }"
  log_group_name = var.cloudtrail_log_group_name

  metric_transformation {
    name          = "root_login"
    namespace     = "GRACECISBenchmark"
    value         = "1"
    default_value = "0"
  }
}

# Alarm root_login
resource "aws_cloudwatch_metric_alarm" "root_login" {
  count               = var.alert_on_console_login_failures ? 1 : 0
  alarm_name          = "root_login"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = "1"
  metric_name         = aws_cloudwatch_log_metric_filter.root_login[count.index].id
  namespace           = "GRACECISBenchmark"
  period              = var.root_login_period
  statistic           = "Sum"
  threshold           = var.root_login_threshold
  treat_missing_data  = "ignore"
  alarm_description   = "Monitoring for root account logins will provide visibility into the use of a fully privileged account and an opportunity to reduce the use of it."
  alarm_actions       = [aws_cloudformation_stack.alerting_topic.outputs["Arn"]]
}

# Metric console_login_failures
resource "aws_cloudwatch_log_metric_filter" "console_login_failures" {
  count          = var.alert_on_console_login_failures ? 1 : 0
  name           = "console_login_failures"
  pattern        = "{ ($.eventName = ConsoleLogin) && ($.errorMessage = \"Failed authentication\") }"
  log_group_name = var.cloudtrail_log_group_name

  metric_transformation {
    name          = "console_login_failures"
    namespace     = "GRACECISBenchmark"
    value         = "1"
    default_value = "0"
  }
}

# Alarm console_login_failures
resource "aws_cloudwatch_metric_alarm" "console_login_failures" {
  count               = var.alert_on_console_login_failures ? 1 : 0
  alarm_name          = "console_login_failures"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = "1"
  metric_name         = aws_cloudwatch_log_metric_filter.console_login_failures[count.index].id
  namespace           = "GRACECISBenchmark"
  period              = var.console_login_failures_period
  statistic           = "Sum"
  threshold           = var.console_login_failures_threshold
  treat_missing_data  = "ignore"
  alarm_description   = "Monitoring failed console logins may decrease lead time to detect an attempt to brute force a credential, which may provide an indicator, such as source IP, that can be used in other event correlation."
  alarm_actions       = [aws_cloudformation_stack.alerting_topic.outputs["Arn"]]
}

# Metric disable_or_delete_kms_key
resource "aws_cloudwatch_log_metric_filter" "disable_or_delete_kms_key" {
  count          = var.alert_on_disable_or_delete_kms_key ? 1 : 0
  name           = "disable_or_delete_kms_key"
  pattern        = "{ ($.eventSource = kms.amazonaws.com) && (($.eventName = DisableKey) || ($.eventName = ScheduleKeyDeletion)) }"
  log_group_name = var.cloudtrail_log_group_name

  metric_transformation {
    name          = "disable_or_delete_kms_key"
    namespace     = "GRACECISBenchmark"
    value         = "1"
    default_value = "0"
  }
}

# Alarm disable_or_delete_kms_key
resource "aws_cloudwatch_metric_alarm" "disable_or_delete_kms_key" {
  count               = var.alert_on_disable_or_delete_kms_key ? 1 : 0
  alarm_name          = "disable_or_delete_kms_key"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = "1"
  metric_name         = aws_cloudwatch_log_metric_filter.disable_or_delete_kms_key[count.index].id
  namespace           = "GRACECISBenchmark"
  period              = var.disable_or_delete_kms_key_period
  statistic           = "Sum"
  threshold           = var.disable_or_delete_kms_key_threshold
  treat_missing_data  = "ignore"
  alarm_description   = "Monitoring failed console logins may decrease lead time to detect an attempt to brute force a credential, which may provide an indicator, such as source IP, that can be used in other event correlation."
  alarm_actions       = [aws_cloudformation_stack.alerting_topic.outputs["Arn"]]
}

# Metric console_signin_without_mfa
resource "aws_cloudwatch_log_metric_filter" "console_signin_without_mfa" {
  count          = var.alert_on_console_signin_without_mfa ? 1 : 0
  name           = "console_signin_without_mfa"
  pattern        = "{ ($.eventName = ConsoleLogin) && ($.additionalEventData.MFAUsed = No) }"
  log_group_name = var.cloudtrail_log_group_name

  metric_transformation {
    name          = "console_signin_without_mfa"
    namespace     = "GRACECISBenchmark"
    value         = "1"
    default_value = "0"
  }
}

# Alarm console_signin_without_mfa
resource "aws_cloudwatch_metric_alarm" "console_signin_without_mfa" {
  count               = var.alert_on_console_signin_without_mfa ? 1 : 0
  alarm_name          = "console_signin_without_mfa"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = "1"
  metric_name         = aws_cloudwatch_log_metric_filter.console_signin_without_mfa[count.index].id
  namespace           = "GRACECISBenchmark"
  period              = var.console_signin_without_mfa_period
  statistic           = "Sum"
  threshold           = var.console_signin_without_mfa_threshold
  treat_missing_data  = "ignore"
  alarm_description   = "Monitoring for console logins without MFA will provide visibility into all console logins that do not utilize MFA."
  alarm_actions       = [aws_cloudformation_stack.alerting_topic.outputs["Arn"]]
}

