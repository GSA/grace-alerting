resource "aws_securityhub_account" "account" {
}

resource "aws_securityhub_standards_subscription" "foundations" {
  depends_on    = [aws_securityhub_account.account]
  standards_arn = "arn:aws:securityhub:::standards/aws-foundational-security-best-practices/v/1.0.0"
}

resource "aws_securityhub_standards_subscription" "cis" {
  depends_on    = [aws_securityhub_account.account]
  standards_arn = "arn:aws:securityhub:::ruleset/cis-aws-foundations-benchmark/v/1.2.0"
}

resource "aws_securityhub_product_subscription" "guardduty" {
  depends_on  = [aws_securityhub_account.account]
  product_arn = "arn:aws:securityhub:${local.region}::product/aws/guardduty"
}