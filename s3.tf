locals {
  redirect_to_vk = jsonencode(
    [
      {
        Redirect = {
          Protocol             = "https"
          HostName             = "vk.com"
          HttpRedirectCode     = "301"
          ReplaceKeyPrefixWith = "e_dub#"
        }
      },
    ]
  )
}

resource "aws_s3_bucket" "root" {
  bucket = var.hostname

  acl = "private"
  website {
    index_document = "index.html"
    routing_rules  = local.redirect_to_vk
  }
  tags = local.tags

  lifecycle {
    prevent_destroy = true
  }
}

resource "aws_s3_bucket" "www" {
  bucket = "www.${var.hostname}"

  acl = "private"
  website {
    index_document = "index.html"
    routing_rules  = local.redirect_to_vk
  }
  tags = local.tags

  lifecycle {
    prevent_destroy = true
  }
}
