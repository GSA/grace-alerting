resource "aws_guardduty_detector" "detector" {
  enable = var.guardduty_enabled
}
