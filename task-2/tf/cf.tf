resource "aws_cloudfront_distribution" "lorem_ipsum" {
  depends_on = [aws_s3_bucket.lorem_ipsum_bucket]

  origin {
    domain_name = aws_s3_bucket.lorem_ipsum_bucket.bucket_domain_name
    origin_id   = "lorem-ipsum-s3-origin"
  }

  enabled             = true
  default_root_object = "index.html" 

  default_cache_behavior {
    viewer_protocol_policy = "redirect-to-https"
    allowed_methods        = ["DELETE", "GET", "HEAD", "OPTIONS", "PATCH", "POST", "PUT"]
    cached_methods         = ["GET", "HEAD", "OPTIONS"]

    forwarded_values {
      query_string = false

      cookies {
        forward = "none"
      }
    }

    min_ttl                = 0
    default_ttl            = 3600
    max_ttl                = 86400

    target_origin_id = "lorem-ipsum-s3-origin"
  }

  restrictions {
    geo_restriction {
       restriction_type  = "blacklist"
       locations         = ["CN", "HK"]
  #    restriction_type = "whitelist"
  #    locations        = ["US", "CA", "GB", "DE", "FR"]
    }
  }

  viewer_certificate {
    cloudfront_default_certificate = true
  }
}
