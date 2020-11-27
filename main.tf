locals {
  bucket_count = var.logging_enabled ? 1 : 0
}

resource "aws_s3_bucket" "bucket" {
  count = local.bucket_count

  bucket = var.logging_config_bucket
  acl    = "private"

  versioning {
    enabled = false
  }

  force_destroy = true

  tags = var.tags
}

resource "aws_cloudfront_distribution" "cdn" {
  origin {
    domain_name = var.origin_domain_name == "" ? data.terraform_remote_state.alb.outputs.dns_name : var.origin_domain_name
    origin_id   = data.terraform_remote_state.alb.outputs.load_balancer_id

    custom_origin_config {
      http_port                = var.origin_http_port
      https_port               = var.origin_https_port
      origin_keepalive_timeout = var.origin_keepalive_timeout
      origin_protocol_policy   = var.origin_protocol_policy
      origin_read_timeout      = var.origin_read_timeout
      origin_ssl_protocols     = var.origin_ssl_protocols
    }
  }

  dynamic "logging_config" {
    for_each = var.logging_enabled ? [1] : []
    content {
      bucket          = aws_s3_bucket.bucket[local.bucket_count - 1].bucket_domain_name
      include_cookies = var.logging_config_include_cookies
    }
  }

  aliases             = var.aliases
  enabled             = var.enabled
  is_ipv6_enabled     = var.is_ipv6_enabled
  comment             = var.comment
  default_root_object = var.default_root_object

  default_cache_behavior {
    allowed_methods  = var.allowed_methods
    cached_methods   = var.cached_methods
    target_origin_id = data.terraform_remote_state.alb.outputs.load_balancer_id

    forwarded_values {
      query_string = var.forward_query_string
      headers      = var.forwarded_headers
      cookies {
        forward = var.forwarded_cookies
      }
    }

    viewer_protocol_policy = var.viewer_protocol_policy
    min_ttl                = var.min_ttl
    default_ttl            = var.default_ttl
    max_ttl                = var.max_ttl
  }

  price_class = var.price_class

  viewer_certificate {
    acm_certificate_arn      = var.acm_certificate_arn
    minimum_protocol_version = var.minimum_protocol_version
    ssl_support_method       = var.ssl_support_method
  }

  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }
  
  web_acl_id = can(var.web_acl_id) ? var.web_acl_id : null

  tags = var.tags
}

resource "aws_route53_record" "cdn_record" {
  for_each = toset(var.aliases)

  name    = each.value
  zone_id = var.route_53_zone_id
  type    = "A"

  alias {
    name                   = aws_cloudfront_distribution.cdn.domain_name
    zone_id                = aws_cloudfront_distribution.cdn.hosted_zone_id
    evaluate_target_health = true
  }
}
