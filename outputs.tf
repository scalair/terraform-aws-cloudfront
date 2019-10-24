output "id" {
  value       = aws_cloudfront_distribution.cdn.id
  description = "ID of AWS CloudFront distribution"
}

output "arn" {
  value       = aws_cloudfront_distribution.cdn.arn
  description = "ID of AWS CloudFront distribution"
}

output "status" {
  value       = aws_cloudfront_distribution.cdn.status
  description = "Current status of the distribution"
}

output "domain_name" {
  value       = aws_cloudfront_distribution.cdn.domain_name
  description = "Domain name corresponding to the distribution"
}

output "etag" {
  value       = aws_cloudfront_distribution.cdn.etag
  description = "Current version of the distribution's information"
}

output "hosted_zone_id" {
  value       = aws_cloudfront_distribution.cdn.hosted_zone_id
  description = "CloudFront Route 53 zone ID"
}

output "last_modified_time" {
  value       = aws_cloudfront_distribution.cdn.last_modified_time
  description = "The date and time the distribution was last modified"
}