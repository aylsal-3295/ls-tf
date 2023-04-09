output "role_arn" {
  value = aws_iam_role.Lightspin-secaudit-role.arn
}
output "external_id" {
  value = "${var.external_id}"
}
