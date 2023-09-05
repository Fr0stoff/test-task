#
variable "aws_region" {
  default = "us-east-1"
}

#
locals {
  source_files = fileset("../content", "**/*")
  content_types = {
    ".html" = "text/html",
    ".svg"  = "image/svg+xml",
  }
}
