resource "aws_s3_bucket" "lorem_ipsum_bucket" {
  bucket = "lorem-ipsum-bucket"
}

resource "aws_s3_bucket_public_access_block" "lorem_ipsum_block" {
  bucket = aws_s3_bucket.lorem_ipsum_bucket.id
  block_public_acls   = false
  block_public_policy = false
  restrict_public_buckets = false
  ignore_public_acls = false
}

resource "aws_s3_bucket_ownership_controls" "lorem_ipsum" {
  bucket = aws_s3_bucket.lorem_ipsum_bucket.id
  rule {
    object_ownership = "BucketOwnerPreferred"
  }
}

resource "aws_s3_bucket_acl" "lorem_ipsum_acl" {
  depends_on = [aws_s3_bucket_ownership_controls.lorem_ipsum]
  bucket = aws_s3_bucket.lorem_ipsum_bucket.id
  acl    = "public-read"
}

# Upload each file from the source folder to the S3 bucket
resource "aws_s3_object" "site_files" {
  for_each = { for file in local.source_files : file => file }

  bucket       = aws_s3_bucket.lorem_ipsum_bucket.id
  key          = each.value
  source       = "../content/${each.value}"
  content_type = regex(".*\\.(.*)", each.value)[0]
  acl          = "public-read"
}

resource "aws_s3_bucket_website_configuration" "lorem_ipsum_bucket" {
  bucket = aws_s3_bucket.lorem_ipsum_bucket.bucket

  index_document {
    suffix = "index.html"
  }

  error_document {
    key = "index.html"
  }
}
