data "aws_caller_identity" "current" {}

data "aws_iam_policy" "SecurityAudit" {
  arn = "arn:aws:iam::aws:policy/SecurityAudit"
}

data "aws_iam_policy" "AWSOrganizationsReadOnlyAccess" {
  arn = "arn:aws:iam::aws:policy/AWSOrganizationsReadOnlyAccess"
}

data "aws_iam_policy" "ViewOnlyAccess" {
  arn = "arn:aws:iam::aws:policy/job-function/ViewOnlyAccess"
}