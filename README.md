# <a name="top">GRACE Alerting</a> [![CircleCI](https://circleci.com/gh/GSA/grace-alerting.svg?style=shield)](https://circleci.com/gh/GSA/grace-alerting)

GRACE Alerting provides basic CloudWatch Event Rules and Log Metric Filters that assist with the monitoring of an AWS environment. Results are dispatched to the provided email address using AWS Simple Notification Service, providing a minimalistic alert monitoring solution.

## Table of Contents

- [Security Compliance](#security-compliance)
- [Supported Alerts](#supported-alerts)
- [Repository contents](#repository-contents)
- [Usage](#usage)
- [Terraform Module Inputs](#terraform-module-inputs)
- [Terraform Module Outputs](#terraform-module-outputs)

## Security Compliance

**Component ATO status:** draft

**Relevant controls:**

| Control    | CSP/AWS | HOST/OS | App/DB | How is it implemented? |
| ---------- | ------- | ------- | ------ | ---------------------- |


[top](#top)

## Supported Alerts

### Metrics

*Note: The `period` and `threshold` are adjustable for all metric alarms.*

| Rule Name | Description |
| --------- | ----------- |
| root_login | Alert when the root user logs in to the environment |
| console_signin_failures | Alert on console login failures |
| disable_or_delete_kms_key | Alert when a KMS Key is disabled or scheduled for deletion | 
| console_signin_without_mfa | Alert when a user signs into the AWS Console without using multi-factor authentication | 


### Events

| Rule Name | Description |
| --------- | ----------- |
| scp_changes | Alert on Attach, Detach, Update, Disable, and Enable Service Control Policies and Types |
| s3_bucket_changes | Alert on S3 Bucket access and permission related changes |
| config_compliance_changes | Alert on changes to AWS Config Rule compliance states |
| cloudtrail_configuration_changes | Alert on changes to CloudTrail Logging Configuration |
| config_configuration_changes | Alert on destructive changes to AWS Config service configuration |
| iam_configuration_changes | Alert on changes to AWS IAM configuration |
| guardduty_findings | Alert on findings provided by GuardDuty |


[top](#top)

## Repository contents

- **sns.tf** contains the CloudFormation stack declaration for the `alerting-topic` SNS Topic
- **metrics.tf** contains all of the declarations for CloudWatch metrics filters and alarms
- **events.tf** contains all of the declarations for CloudWatch event rules and targets
- **variables.tf** contains all configurable variables
- **outputs.tf** contains all Terraform output variables

[top](#top)

# Usage

Simply import grace-alerting as a module into your Terraform for the destination AWS Environment.

```
module "alerting" {
    source                    = "github.com/GSA/grace-alerting?ref=v0.0.1"
    cloudtrail_log_group_name = "<log_group_name>"
    recipient                 = "<email_address>"
}
```

[top](#top)

## Terraform Module Inputs

| Name | Description | Type | Default | Required |
|------|-------------|:----:|:-----:|:-----:|
| cloudtrail_log_group_name | The CloudTrail Log Group name | string |  | yes |
| recipient | The Email Address that should receive alerts | string |  | yes |
| alert_on_root_login | Alert when the root user logs in to the environment | bool | true | no |
| root_login_period | Duration in seconds to capture events before resetting the count | number | 300 | no |
| root_login_threshold | Number of captured events required before triggering the alarm | number | 1 | no |
| alert_on_console_login_failures | Alert on console login failures | bool | true | no |
| console_login_failures_period | Duration in seconds to capture events before resetting the count | number | 300 | no |
| console_login_failures_threshold | Number of captured events required before triggering the alarm | number | 5 | no |
| alert_on_disable_or_delete_kms_key | Alert when a KMS Key is disabled or scheduled for deletion | bool | true | no |
| disable_or_delete_kms_key_period | Duration in seconds to capture events before resetting the count | number | 300 | no |
| disable_or_delete_kms_key_threshold | Number of captured events required before triggering the alarm | number | 1 | no |
| alert_on_console_login_without_mfa | Alert when a user signs into the AWS Console without using multi-factor authentication | bool | true | no |
| console_login_without_mfa_period | Duration in seconds to capture events before resetting the count | number | 300 | no |
| console_login_without_mfa_threshold | Number of captured events required before triggering the alarm | number | 1 | no |
| alert_on_scp_changes | Alert on Attach, Detach, Update, Disable, and Enable Service Control Policies and Types | bool | true | no |
| alert_on_s3_bucket_changes | Alert on S3 Bucket access and permission related changes | bool | true | no |
| alert_on_config_compliance_changes | Alert on changes to AWS Config Rule compliance states | bool | true | no |
| alert_on_cloudtrail_configuration_changes | Alert on changes to CloudTrail Logging Configuration | bool | true | no |
| alert_on_config_configuration_changes | Alert on destructive changes to AWS Config service configuration | bool | true | no |
| alert_on_iam_configuration_changes | Alert on changes to AWS IAM configuration | bool | true | no |
| alert_on_guardduty_findings | Alert on findings provided by GuardDuty | bool | true | no |

[top](#top)

## Terraform Module Outputs

| Name | Description |
|------|-------------|
| alerting_topic_arn | The Amazon Resource Name (ARN) identifying the Alerting SNS Topic |

[top](#top)

## Public domain

This project is in the worldwide [public domain](LICENSE.md). As stated in [CONTRIBUTING](CONTRIBUTING.md):

> This project is in the public domain within the United States, and copyright and related rights in the work worldwide are waived through the [CC0 1.0 Universal public domain dedication](https://creativecommons.org/publicdomain/zero/1.0/).
>
> All contributions to this project will be released under the CC0 dedication. By submitting a pull request, you are agreeing to comply with this waiver of copyright interest.

[top](#top)