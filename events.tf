#######################
# Cloudwatch Events   #
#######################

# Rule scp_changes
resource "aws_cloudwatch_event_rule" "scp_changes" {
  count       = var.alert_on_scp_changes ? 1 : 0
  name        = "scp_changes"
  description = "Trigger on Attach, Detach, Update, Disable, and Enable Service Control Policies and Types"

  event_pattern = <<EOF
{
  "source": [
    "aws.organizations"
  ],
  "detail-type": [
    "AWS API Call via CloudTrail"
  ],
  "detail": {
    "eventSource": [
      "organizations.amazonaws.com"
    ],
    "eventName": [
      "AttachPolicy",
      "DetachPolicy",
      "UpdatePolicy",
      "DisablePolicyType",
      "EnablePolicyType"
    ]
  }
}
EOF

}

# Target scp_changes
resource "aws_cloudwatch_event_target" "scp_changes" {
  count = var.alert_on_scp_changes ? 1 : 0
  rule  = aws_cloudwatch_event_rule.scp_changes[0].name
  arn   = aws_cloudformation_stack.alerting_topic.outputs["ARN"]

  input_transformer {
    input_paths = {
      "EventTime"       = "$.detail.eventTime"
      "EventType"       = "$.detail-type"
      "UserID"          = "$.detail.userIdentity.arn"
      "AccountID"       = "$.detail.userIdentity.accountId"
      "SourceIP"        = "$.detail.sourceIPAddress"
      "UserAgent"       = "$.detail.userAgent"
      "EventSource"     = "$.detail.eventSource"
      "AWSRegion"       = "$.detail.awsRegion"
      "EventName"       = "$.detail.eventName"
      "EventParameters" = "$.detail.requestParameters[*]"
    }

    input_template = <<EOF
{
  "Event Time": <EventTime>,
  "Event Type":<EventType>,
  "User ID": <UserID>,
  "Account ID": <AccountID>,
  "Source IP": <SourceIP>,
  "User Agent": <UserAgent>,
  "Event Source": <EventSource>,
  "AWS Region": <AWSRegion>,
  "Event Name": <EventName>,
  "Event Parameters": <EventParameters>
}
EOF

  }
}

# Rule s3_bucket_changes
resource "aws_cloudwatch_event_rule" "s3_bucket_changes" {
  count       = var.alert_on_s3_bucket_changes ? 1 : 0
  name        = "s3_bucket_changes"
  description = "Trigger on S3 Bucket access and permission related changes"

  event_pattern = <<EOF
{
  "detail": {
    "eventName": [
      "PutBucketAcl",
      "PutBucketPolicy",
      "PutBucketCors",
      "PutBucketLifecycle",
      "PutBucketReplication",
      "DeleteBucketPolicy",
      "DeleteBucketCors",
      "DeleteBucketLifecycle",
      "DeleteBucketReplication"
    ],
    "eventSource": [
      "s3.amazonaws.com"
    ]
  },
  "detail-type": [
    "AWS API Call via CloudTrail"
  ],
  "source": [
    "aws.s3"
  ]
}
EOF
}

# Target s3_bucket_changes
resource "aws_cloudwatch_event_target" "s3_bucket_changes" {
  count = var.alert_on_s3_bucket_changes ? 1 : 0
  rule  = aws_cloudwatch_event_rule.s3_bucket_changes.name
  arn   = aws_cloudformation_stack.alerting_topic.outputs["ARN"]

  input_transformer {
    input_paths = {
      "EventTime"       = "$.detail.eventTime"
      "EventType"       = "$.detail-type"
      "UserID"          = "$.detail.userIdentity.arn"
      "AccountID"       = "$.detail.userIdentity.accountId"
      "SourceIP"        = "$.detail.sourceIPAddress"
      "UserAgent"       = "$.detail.userAgent"
      "EventSource"     = "$.detail.eventSource"
      "AWSRegion"       = "$.detail.awsRegion"
      "EventName"       = "$.detail.eventName"
      "EventParameters" = "$.detail.requestParameters[*]"
    }

    input_template = <<EOF
{
  "Event Time": <EventTime>,
  "Event Type":<EventType>,
  "User ID": <UserID>,
  "Account ID": <AccountID>,
  "Source IP": <SourceIP>,
  "User Agent": <UserAgent>,
  "Event Source": <EventSource>,
  "AWS Region": <AWSRegion>,
  "Event Name": <EventName>,
  "Event Parameters": <EventParameters>
}
EOF

  }
}

# Rule config_compliance_changes
resource "aws_cloudwatch_event_rule" "config_compliance_changes" {
  count       = var.alert_on_config_compliance_changes ? 1 : 0
  name        = "config_compliance_changes"
  description = "Trigger on changes to AWS Config Rule compliance states"

  event_pattern = <<EOF
{
  "source": [
    "aws.config"
  ],
  "detail-type": [
    "Config Rules Compliance Change"
  ]
}
EOF
}

# Target config_compliance_changes
resource "aws_cloudwatch_event_target" "config_compliance_changes" {
  count = var.alert_on_config_compliance_changes ? 1 : 0
  rule  = aws_cloudwatch_event_rule.config_compliance_changes.name
  arn   = aws_cloudformation_stack.alerting_topic.outputs["ARN"]

  input_transformer {
    input_paths = {
      "EventTime"           = "$.time"
      "EventType"           = "$.detail-type"
      "AWSRegion"           = "$.detail.awsRegion"
      "AWSAccount"          = "$.detail.awsAccountId"
      "ConfigRuleName"      = "$.detail.newEvaluationResult.evaluationResultIdentifier.evaluationResultQualifier.configRuleName"
      "ResourceType"        = "$.detail.newEvaluationResult.evaluationResultIdentifier.evaluationResultQualifier.resourceType"
      "ResourceID"          = "$.detail.newEvaluationResult.evaluationResultIdentifier.evaluationResultQualifier.resourceId"
      "NewComplianceStatus" = "$.detail.newEvaluationResult.complianceType"
      "OldComplianceStatus" = "$.detail.oldEvaluationResult.complianceType"
    }

    input_template = <<EOF
{
  "Event Time": <EventTime>,
  "Event Type":<EventType>,
  "AWS Region": <AWSRegion>,
  "AWS Account": <AWSAccount>,
  "Config Rule": <ConfigRuleName>,
  "Resource Type": <ResourceType>,
  "Resource ID": <ResourceID>,
  "New Compliance State": <NewComplianceStatus>,
  "Old Compliance State": <OldComplianceStatus>
}
EOF

  }
}

# Rule cloudtrail_configuration_changes
resource "aws_cloudwatch_event_rule" "cloudtrail_configuration_changes" {
  count       = var.alert_on_cloudtrail_configuration_changes ? 1 : 0
  name        = "cloudtrail_configuration_changes"
  description = "Trigger on changes to CloudTrail Logging Configuration"

  event_pattern = <<EOF
{
  "detail": {
    "eventName": [
      "StopLogging",
      "StartLogging",
      "UpdateTrail",
      "DeleteTrail",
      "CreateTrail",
      "RemoveTags",
      "AddTags",
      "PutEventSelectors"
    ],
    "eventSource": [
      "cloudtrail.amazonaws.com"
    ]
  },
  "detail-type": [
    "AWS API Call via CloudTrail"
  ],
  "source": [
    "aws.cloudtrail"
  ]
}
EOF
}

# Target cloudtrail_configuration_changes
resource "aws_cloudwatch_event_target" "sns_cloudtrail_configuration_changes" {
  count = var.alert_on_cloudtrail_configuration_changes ? 1 : 0
  rule  = aws_cloudwatch_event_rule.cloudtrail_configuration_changes.name
  arn   = aws_cloudformation_stack.alerting_topic.outputs["ARN"]

  input_transformer {
    input_paths = {
      "EventTime"       = "$.detail.eventTime"
      "EventType"       = "$.detail-type"
      "UserID"          = "$.detail.userIdentity.arn"
      "SourceIP"        = "$.detail.sourceIPAddress"
      "UserAgent"       = "$.detail.userAgent"
      "EventSource"     = "$.detail.eventSource"
      "AWSRegion"       = "$.detail.awsRegion"
      "EventName"       = "$.detail.eventName"
      "EventParameters" = "$.detail.requestParameters[*]"
    }

    input_template = <<EOF
{
  "Event Time": <EventTime>,
  "Event Type":<EventType>,
  "User ID": <UserID>,
  "Source IP": <SourceIP>,
  "User Agent": <UserAgent>,
  "Event Source": <EventSource>,
  "AWS Region": <AWSRegion>,
  "Event Name": <EventName>,
  "Event Parameters": <EventParameters>
}
EOF

  }
}

# Rule config_configuration_changes
resource "aws_cloudwatch_event_rule" "config_configuration_changes" {
  count       = var.alert_on_config_configuration_changes ? 1 : 0
  name        = "config_configuration_changes"
  description = "Trigger on destructive changes to AWS Config service configuration"

  event_pattern = <<EOF
{
  "source": [
    "aws.config"
  ],
  "detail-type": [
    "AWS API Call via CloudTrail"
  ],
  "detail": {
    "eventSource": [
      "config.amazonaws.com"
    ],
    "eventName": [
      "DeleteDeliveryChannel",
      "DeleteConfigurationRecorder",
      "StopConfigurationRecorder",
      "DeleteConfigRule",
      "DeleteEvaluationResults",
      "DeletePendingAggregationRequest",
      "DeleteAggregationAuthorization",
      "DeleteConfigurationAggregator"
    ]
  }
}
EOF

}

# Target config_configuration_changes
resource "aws_cloudwatch_event_target" "sns_config_configuration_changes" {
  count = var.alert_on_config_configuration_changes ? 1 : 0
  rule  = aws_cloudwatch_event_rule.config_configuration_changes.name
  arn   = aws_cloudformation_stack.alerting_topic.outputs["ARN"]

  input_transformer {
    input_paths = {
      "EventTime"       = "$.detail.eventTime"
      "EventType"       = "$.detail-type"
      "UserID"          = "$.detail.userIdentity.arn"
      "AccountID"       = "$.detail.userIdentity.accountId"
      "SourceIP"        = "$.detail.sourceIPAddress"
      "UserAgent"       = "$.detail.userAgent"
      "EventSource"     = "$.detail.eventSource"
      "AWSRegion"       = "$.detail.awsRegion"
      "EventName"       = "$.detail.eventName"
      "EventParameters" = "$.detail.requestParameters[*]"
    }

    input_template = <<EOF
{
  "Event Time": <EventTime>,
  "Event Type":<EventType>,
  "User ID": <UserID>,
  "Account ID": <AccountID>,
  "Source IP": <SourceIP>,
  "User Agent": <UserAgent>,
  "Event Source": <EventSource>,
  "AWS Region": <AWSRegion>,
  "Event Name": <EventName>,
  "Event Parameters": <EventParameters>
}
EOF

  }
}

# Rule iam_configuration_changes
resource "aws_cloudwatch_event_rule" "iam_configuration_changes" {
  count       = var.alert_on_iam_configuration_changes ? 1 : 0
  name        = "iam_configuration_changes"
  description = "Trigger on changes to AWS IAM configuration"

  event_pattern = <<EOF
{
 "source": [
   "aws.iam"
 ],
 "detail-type": [
   "AWS API Call via CloudTrail"
 ],
 "detail": {
   "eventSource": [
     "iam.amazonaws.com"
   ],
   "eventName": [
     "AddUserToGroup",
     "AttachGroupPolicy",
     "AttachRolePolicy",
     "AttachUserPolicy",
     "CreateAccessKey",
     "CreateAccountAlias",
     "CreateGroup",
     "CreateLoginProfile",
     "CreatePolicy",
     "CreateRole",
     "CreateServiceLinkedRole",
     "CreateUser",
     "CreateVirtualMFADevice",
     "DeactivateMFADevice",
     "DeleteAccessKey",
     "DeleteAccountAlias",
     "DeleteAccountPasswordPolicy",
     "DeleteGroup",
     "DeleteGroupPolicy",
     "DeleteLoginProfile",
     "DeletePolicy",
     "DeleteRole",
     "DeleteRolePolicy",
     "DeleteSSHPublicKey",
     "DeleteServiceLinkedRole",
     "DeleteUser",
     "DeleteUserPermissionsBoundary",
     "DeleteUserPolicy",
     "DeleteVirtualMFADevice",
     "DetachGroupPolicy",
     "DetachRolePolicy",
     "DetachUserPolicy",
     "PutGroupPolicy",
     "PutRolePolicy",
     "PutUserPolicy",
     "RemoveUserFromGroup",
     "UpdateAccessKey",
     "UpdateAccountPasswordPolicy",
     "UpdateAssumeRolePolicy",
     "UpdateUser"
   ]
 }
}
EOF

}

# Target iam_configuration_changes
resource "aws_cloudwatch_event_target" "sns_iam_configuration_changes" {
  count = var.alert_on_iam_configuration_changes ? 1 : 0
  rule  = aws_cloudwatch_event_rule.iam_configuration_changes.name
  arn   = aws_cloudformation_stack.alerting_topic.outputs["ARN"]

  input_transformer {
    input_paths = {
      "UserARN"     = "$.detail.userIdentity.arn"
      "EventSource" = "$.detail.eventSource"
      "AccountID"   = "$.detail.userIdentity.accountId"
      "SourceIP"    = "$.detail.sourceIPAddress"
      "EventType"   = "$.detail.eventType"
      "EventTime"   = "$.detail.eventTime"
      "UserAgent"   = "$.detail.userAgent"
      "AWSRegion"   = "$.detail.awsRegion"
      "EventName"   = "$.detail.eventName"
      "Elements"    = "$.detail.requestParameters[*]"
    }

    input_template = <<EOF

{
    "Event Time": <EventTime>,
    "User ARN":<UserARN>,
    "Account ID": <AccountID>,
    "Event Source": <EventSource>,
    "Event Type": <EventType>,
    "Event Name": <EventName>,
    "AWS Region": <AWSRegion>,
    "Source IP": <SourceIP>,
    "User Agent": <UserAgent>,
    "Elements": <Elements>
}
EOF

  }
}

# Rule guardduty_findings
resource "aws_cloudwatch_event_rule" "guardduty_findings" {
  count       = var.alert_on_guardduty_findings ? 1 : 0
  name        = "guardduty_findings"
  description = "Trigger on findings provided by GuardDuty"

  event_pattern = <<EOF
{
  "source": [
    "aws.guardduty"
  ],
  "detail-type": [
    "GuardDuty Finding"
  ]
}
EOF

}

# Target guardduty_findings
resource "aws_cloudwatch_event_target" "guardduty_findings" {
  count = var.alert_on_guardduty_findings ? 1 : 0
  rule  = aws_cloudwatch_event_rule.guardduty_findings.name
  arn   = aws_cloudformation_stack.alerting_topic.outputs["ARN"]

  input_transformer {
    input_paths = {
      "EventTime"   = "$.time"
      "EventType"   = "$.detail-type"
      "EventSource" = "$.source"
      "AccountID"   = "$.account"
      "AWSRegion"   = "$.region"
      "Severity"    = "$.detail.severity"
      "Title"       = "$.detail.title"
      "Description" = "$.detail.description"
      "Finding"     = "$.detail"
    }

    input_template = <<EOF
{
    "Event Time": <EventTime>,
    "Event Type": <EventType>,
    "Event Source": <EventSource>,
    "Account ID": <AccountID>,
    "AWS Region": <AWSRegion>,
    "Event Severity": <Severity>,
    "Title": <Title>,
    "Description": <Description>,
    "Finding": <Finding>
}
EOF

  }
}
