# Changelog

## v3.0.0 - 2021-08-20

This release contains *breaking changes*.

### Changed

- Upgrade cloudfront module
- Upgrade s3 bucket module

### Fixed

- Deprecated output values

## v2.0.0 - 2021-02-08

This release contains *breaking changes*.
### Changed

- Using `terraform-aws-cloudfront` module for creating distributions instead of Terraform resource
- Using `terraform-aws-s3-bucket` module for creating log buckets instead of Terraform resource

## v1.4.0 - 2020-11-27
### Changed

- Remove region from `aws_s3_bucket` block since AWS provider v3 doesn't support it anymore

## v1.3.0
### Added
- Web ACL ARN for WAF association

## v1.2.0 - 2020-04-01
### Changed
- Origin domain name can now be provided manually

## v1.1.0 - 2019-11-14
### Added
- S3 bucket for Cloudfront access logs

## v1.0.0 - 2019-10-23
### Added
- Initial commit
