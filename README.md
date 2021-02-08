# Terraform AWS CloudFront

Terraform module which creates a CloudFront distribution.

## Usage

```hcl
module "cloudfront" {
  comment             = "My App Distribution"
  enabled             = true
  create_distribution = true
  is_ipv6_enabled     = true
  price_class         = "PriceClass_100"
  aliases             = ["my-app.domain.com"]
  route53_zone_id     = "xxxxxxxxx"
  web_acl_id          = "xxxxxxxxx"

  logging_config = {
    include_cookies = false
    prefix          = "my-app"
    bucket_name     = "cloudfront-logs.bucket.somewhere"
  }

  origin = {
    # origin ID
    "xxxxxxxxx" = {
      domain_name = "my.origin.domain.com"
      custom_origin_config = {
        http_port                = 80
        https_port               = 443
        origin_keepalive_timeout = 60
        origin_protocol_policy   = "https-only"
        origin_ssl_protocols     = ["TLSv1.2"]
      }
      custom_header = [
        {
          name = "X-Some-Header"
          value = "hey"
        }
      ]
    },
    "s3.public.bucket.somewhere" = {
      domain_name = ""s3.public.bucket.somewhere""
    }
  }

  default_cache_behavior = {
    target_origin_id       = "xxxxxxxxx"
    viewer_protocol_policy = "redirect-to-https"

    allowed_methods = ["GET", "HEAD", "OPTIONS", "PUT", "POST", "PATCH", "DELETE"]
    cached_methods  = ["GET", "HEAD"]

    compress = true

    min_ttl     = "0"
    default_ttl = "604800"   # 7 days
    max_ttl     = "31536000" # 365 days

    query_string    = true
    headers         = ["Accept-Encoding", "Accept-Language", "Authorization"]
    cookies_forward = "all"
  }

  ordered_cache_behavior = [
    {
      path_pattern           = "/error-pages/*"
      target_origin_id       = "s3.public.bucket.somewhere"
      viewer_protocol_policy = "redirect-to-https"

      allowed_methods = ["GET", "HEAD"]
      cached_methods  = ["GET", "HEAD"]

      compress = true

      min_ttl     = "0"
      default_ttl = "0"
      max_ttl     = "0"

      query_string    = false
      headers         = []
      cookies_forward = "none"

    }
  ]

  viewer_certificate = {
    acm_certificate_arn      = "xxxxxxxxx"
    minimum_protocol_version = "TLSv1.2_2019"
    ssl_support_method       = "sni-only"
  }

  custom_error_response = {
    "maintenance" = {
      error_caching_min_ttl = 1
      error_code            = 503
      response_code         = 503
      response_page_path    = "/error-pages/maintenance.html"
    }
  }

  geo_restriction = {
    restriction_type = "whitelist"
    locations        = ["FR"]
  }

  tags = {
    Environment = "non-prod"
    Application = "my-app"
    BU          = "my-company"
    Owner       = "me@example.com"
    AsCode      = "true"
  }
}
```