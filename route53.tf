resource "aws_route53_zone" "zone" {
  name = var.hostname

  tags = local.tags
}

resource "aws_route53_record" "root" {
  zone_id = aws_route53_zone.zone.id
  name    = var.hostname
  type    = "A"

  alias {
    name                   = aws_cloudfront_distribution.root.domain_name
    zone_id                = aws_cloudfront_distribution.root.hosted_zone_id
    evaluate_target_health = false
  }
}

resource "aws_route53_record" "www" {
  zone_id = aws_route53_zone.zone.id
  name    = "www.${var.hostname}"
  type    = "A"

  alias {
    name                   = aws_cloudfront_distribution.www.domain_name
    zone_id                = aws_cloudfront_distribution.www.hosted_zone_id
    evaluate_target_health = false
  }
}

resource "aws_route53_record" "keybase" {
  zone_id = aws_route53_zone.zone.id
  name    = var.hostname
  type    = "TXT"
  ttl     = 300

  records = [
    "keybase-site-verification=OddEYBrtIMDpCs_cMqoCgILoeBDkwx8aD9YqXHhx4XM"
  ]
}

resource "aws_route53_record" "validation" {
  count = 1 + length(aws_acm_certificate.certificate.subject_alternative_names)

  zone_id = aws_route53_zone.zone.id
  name    = aws_acm_certificate.certificate.domain_validation_options[count.index].resource_record_name
  type    = aws_acm_certificate.certificate.domain_validation_options[count.index].resource_record_type
  records = [aws_acm_certificate.certificate.domain_validation_options[count.index].resource_record_value]
  ttl     = 60
}

resource "aws_route53_record" "caa" {
  zone_id = aws_route53_zone.zone.id
  name    = var.hostname
  type    = "CAA"
  ttl     = 300

  records = [
    "0 issue \"amazon.com\"",
    "0 iodef \"mailto:me@sergey-ponomarev.ru\"",
  ]
}

output "name_servers" {
  description = "Domain zone NS servers"
  value       = aws_route53_zone.zone.name_servers
}
