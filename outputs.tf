output "alerting_topic_arn" {
  value       = data.aws_cloudformation_stack.alerting_topic.outputs["ARN"]
  description = "The Amazon Resource Name (ARN) identifying the Alerting SNS Topic"
}
