#######################
# Alerting SNS Topic  #
#######################

# create cloudformation stack
resource "aws_cloudformation_stack" "alerting_topic" {
  name          = "alerting-topic"
  template_body = templatefile("${path.module}/files/alerting-topic.json", { recipient : var.recipient })
}

# read cloudformation stack
data "aws_cloudformation_stack" "alerting_topic" {
  name = "alerting-topic"
}
