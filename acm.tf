resource "aws_acm_certificate" "certificate" {
  domain_name = var.hostname
  subject_alternative_names = [
    "www.${var.hostname}"
  ]
  validation_method = "DNS"
  tags              = merge(local.tags, { Name = var.project })

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_acm_certificate_validation" "certificate" {
  certificate_arn         = aws_acm_certificate.certificate.arn
  validation_record_fqdns = aws_route53_record.validation.*.fqdn
}
