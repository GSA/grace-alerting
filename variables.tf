variable "recipient" {
  type        = string
  description = "(required) The Email Address that should receive alerts"
}

variable "cloudtrail_log_group_name" {
  type        = string
  description = "(required) The CloudTrail Log Group name"
}

variable "alert_on_root_login" {
  type        = bool
  description = "(optional) Alert when the root user logs in to the environment"
  default     = true
}

variable "root_login_period" {
  type        = number
  description = "(optional) Duration in seconds to capture events before resetting the count"
  default     = 300
}

variable "root_login_threshold" {
  type        = number
  description = "(optional) Number of captured events required before triggering the alarm"
  default     = 1
}

variable "alert_on_console_login_failures" {
  type        = bool
  description = "(optional) Alert on console login failures"
  default     = true
}

variable "console_login_failures_period" {
  type        = number
  description = "(optional) Duration in seconds to capture events before resetting the count"
  default     = 300
}

variable "console_login_failures_threshold" {
  type        = number
  description = "(optional) Number of captured events required before triggering the alarm"
  default     = 5
}

variable "alert_on_disable_or_delete_kms_key" {
  type        = bool
  description = "(optional) Alert when a KMS Key is disabled or scheduled for deletion"
  default     = true
}

variable "disable_or_delete_kms_key_period" {
  type        = number
  description = "(optional) Duration in seconds to capture events before resetting the count"
  default     = 300
}

variable "disable_or_delete_kms_key_threshold" {
  type        = number
  description = "(optional) Number of captured events required before triggering the alarm"
  default     = 1
}

variable "alert_on_console_signin_without_mfa" {
  type        = bool
  description = "(optional) Alert when a user signs into the AWS Console without using multi-factor authentication"
  default     = true
}

variable "console_signin_without_mfa_period" {
  type        = number
  description = "(optional) Duration in seconds to capture events before resetting the count"
  default     = 300
}

variable "console_signin_without_mfa_threshold" {
  type        = number
  description = "(optional) Number of captured events required before triggering the alarm"
  default     = 1
}

variable "alert_on_scp_changes" {
  type        = bool
  description = "(optional) Alert on Attach, Detach, Update, Disable, and Enable Service Control Policies and Types"
  default     = true
}

variable "alert_on_s3_bucket_changes" {
  type        = bool
  description = "(optional) Alert on S3 Bucket access and permission related changes"
  default     = true
}

variable "alert_on_config_compliance_changes" {
  type        = bool
  description = "(optional) Alert on changes to AWS Config Rule compliance states"
  default     = true
}

variable "alert_on_cloudtrail_configuration_changes" {
  type        = bool
  description = "(optional) Alert on changes to CloudTrail Logging Configuration"
  default     = true
}

variable "alert_on_config_configuration_changes" {
  type        = bool
  description = "(optional) Alert on destructive changes to AWS Config service configuration"
  default     = true
}

variable "alert_on_iam_configuration_changes" {
  type        = bool
  description = "(optional) Alert on changes to AWS IAM configuration"
  default     = true
}

variable "alert_on_guardduty_findings" {
  type        = bool
  description = "(optional) Alert on findings provided by GuardDuty"
  default     = true
}
