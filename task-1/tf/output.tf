#
output "bucket_name" {
  value = aws_s3_bucket.lorem_ipsum_bucket.id
}
#
output "s3_bucket_bucket_domain_name" {
  value = aws_s3_bucket.lorem_ipsum_bucket.bucket_domain_name
}
#
output "s3_bucket_bucket_regional_domain_name" {
  value = aws_s3_bucket.lorem_ipsum_bucket.bucket_regional_domain_name
}
#
output "cloudfront_domain_name" {
  value = aws_cloudfront_distribution.lorem_ipsum.domain_name
}
