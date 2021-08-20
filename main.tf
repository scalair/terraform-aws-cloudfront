module "cloudfront" {
  source                        = "terraform-aws-modules/cloudfront/aws"
  version                       = "~> 2.7"
  aliases                       = var.aliases
  comment                       = var.comment
  create_distribution           = var.create_distribution
  create_origin_access_identity = length(var.origin_access_identities) != 0 ? true : false
  custom_error_response         = var.custom_error_response
  default_cache_behavior        = var.default_cache_behavior
  default_root_object           = var.default_root_object
  enabled                       = var.enabled
  geo_restriction               = var.geo_restriction
  http_version                  = var.http_version
  is_ipv6_enabled               = var.is_ipv6_enabled
  ordered_cache_behavior        = var.ordered_cache_behavior
  origin                        = var.origin
  origin_access_identities      = var.origin_access_identities
  origin_group                  = var.origin_group
  price_class                   = var.price_class
  retain_on_delete              = var.retain_on_delete
  viewer_certificate            = var.viewer_certificate
  wait_for_deployment           = var.wait_for_deployment
  web_acl_id                    = var.web_acl_id
  logging_config = length(var.logging_config) != 0 ? {
    bucket          = module.log_bucket.*.s3_bucket_bucket_domain_name
    include_cookies = lookup(var.logging_config, "include_cookies", false)
    prefix          = lookup(var.logging_config, "prefix", "")
  } : {}
  tags = var.tags
}

data "aws_canonical_user_id" "current" {}

module "log_bucket" {
  source        = "terraform-aws-modules/s3-bucket/aws"
  version       = "~> v2.7"
  count         = length(var.logging_config) != 0 ? 1 : 0
  bucket        = lookup(var.logging_config, "bucket_name", null)
  force_destroy = true
  acl           = null
  grant = [{
    type        = "CanonicalUser"
    permissions = ["FULL_CONTROL"]
    id          = data.aws_canonical_user_id.current.id
    }, {
    type        = "CanonicalUser"
    permissions = ["FULL_CONTROL"]
    id          = "c4c1ede66af53448b93c283ce9448c4ba468c9432aa01d700d3878632f77d2d0"
    # Ref. https://github.com/terraform-providers/terraform-provider-aws/issues/12512
    # Ref. https://docs.aws.amazon.com/AmazonCloudFront/latest/DeveloperGuide/AccessLogs.html
  }]
  tags = var.tags
}

resource "aws_route53_record" "record" {
  for_each = toset(var.aliases)
  name     = each.value
  zone_id  = var.route53_zone_id
  type     = "A"
  alias {
    name                   = module.cloudfront.cloudfront_distribution_domain_name
    zone_id                = module.cloudfront.cloudfront_distribution_hosted_zone_id
    evaluate_target_health = true
  }
}
