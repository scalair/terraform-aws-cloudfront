####################
# ALB remote state #
####################
variable "alb_bucket" {
  description = "Name of the bucket where ALB state is stored"
}

variable "alb_state_key" {
  description = "Key where the state file of the ALB is stored"
}

variable "alb_state_region" {
  description = "Region where the state file of the ALB is stored"
}

#######
# CDN #
#######
variable "name" {
  description = "Name  (e.g. `bastion` or `db`)"
}

variable "enabled" {
  description = "Set to false to prevent the module from creating any resources"
  default     = true
}

variable "tags" {
  description = "Additional tags (e.g. `map('BusinessUnit','XYZ')`)"
  type        = map
  default     = {}
}

variable "acm_certificate_arn" {
  description = "Existing ACM Certificate ARN"
  default     = ""
}

variable "aliases" {
  description = "List of aliases. CAUTION! Names MUSTN'T contain trailing `.`"
  type        = list(string)
  default     = []
}

variable "origin_domain_name" {
  description = "The domain name of the custom origin. If not set, terraform will use ALB domain name/"
  default     = ""
}

variable "origin_http_port" {
  description = "(Required) - The HTTP port the custom origin listens on"
  default     = "80"
}

variable "origin_https_port" {
  description = "(Required) - The HTTPS port the custom origin listens on"
  default     = "443"
}

variable "origin_protocol_policy" {
  description = "(Required) - The origin protocol policy to apply to your origin. One of http-only, https-only, or match-viewer"
  default     = "match-viewer"
}

variable "origin_ssl_protocols" {
  description = "(Required) - The SSL/TLS protocols that you want CloudFront to use when communicating with your origin over HTTPS"
  type        = list(string)
  default     = ["TLSv1", "TLSv1.1", "TLSv1.2"]
}

variable "origin_keepalive_timeout" {
  description = "(Optional) The Custom KeepAlive timeout, in seconds. By default, AWS enforces a limit of 60. But you can request an increase."
  default     = "60"
}

variable "origin_read_timeout" {
  description = "(Optional) The Custom Read timeout, in seconds. By default, AWS enforces a limit of 60. But you can request an increase."
  default     = "60"
}

variable "is_ipv6_enabled" {
  description = "State of CloudFront IPv6"
  default     = "true"
}

variable "default_root_object" {
  description = "Object that CloudFront return when requests the root URL"
  default     = ""
}

variable "comment" {
  description = "Comment for the origin access identity"
  default     = "Managed by Terraform"
}

variable "price_class" {
  description = "Price class for this distribution: `PriceClass_All`, `PriceClass_200`, `PriceClass_100`"
  default     = "PriceClass_100"
}

variable "viewer_protocol_policy" {
  description = "allow-all, redirect-to-https"
  default     = "redirect-to-https"
}

variable "allowed_methods" {
  description = "List of allowed methods (e.g. ` GET, PUT, POST, DELETE, HEAD`) for AWS CloudFront"
  type        = list(string)
  default     = ["DELETE", "GET", "HEAD", "OPTIONS", "PATCH", "POST", "PUT"]
}

variable "cached_methods" {
  description = "List of cached methods (e.g. ` GET, PUT, POST, DELETE, HEAD`)"
  type        = list(string)
  default     = ["GET", "HEAD"]
}

variable "default_ttl" {
  description = "Default amount of time (in seconds) that an object is in a CloudFront cache"
  default     = "60"
}

variable "min_ttl" {
  description = "Minimum amount of time that you want objects to stay in CloudFront caches"
  default     = "0"
}

variable "max_ttl" {
  description = "Maximum amount of time (in seconds) that an object is in a CloudFront cache"
  default     = "31536000"
}

variable "minimum_protocol_version" {
  description = "The minimum version of the SSL protocol that you want CloudFront to use for HTTPS connections"
  default     = "TLSv1"
}

variable "ssl_support_method" {
  description = "Specifies how you want CloudFront to serve HTTPS requests"
  default     = "sni-only"
}

variable "route_53_zone_id" {
  description = "ID of the Route 53 Zone where records will be made"
}

variable "forward_query_string" {
  type    = bool
  default = true
}

variable "forwarded_headers" {
  type    = list(string)
  default = []
}

variable "forwarded_cookies" {
  type    = string
  default = "none"
}

variable "logging_enabled" {
  description = "Boolean to enable / disable access_logs"
  type        = bool
  default     = false
}

variable "logging_config_include_cookies" {
  description = "Specifies whether you want CloudFront to include cookies in access logs"
  type        = bool
  default     = false
}

variable "logging_config_bucket" {
  description = "The Amazon S3 bucket to store the access logs in, for example"
  type        = string
}

variable "web_acl_id" {
  description = " If you're using AWS WAF to filter CloudFront requests, the Id of the AWS WAF web ACL that is associated with the distribution"
  type        = string
  default     = null
}
