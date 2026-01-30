
resource "aws_s3_bucket" "public_website" {
  bucket = "my-public-website-demo"

  tags = {
    environment = "prod"
    public_facing = "true"
    data_class  = "public"
    managed_by  = "terraform"
  }
}

resource "aws_s3_bucket_website_configuration" "public_website" {
  bucket = aws_s3_bucket.public_website.id

  index_document {
    suffix = "index.html"
  }
}

resource "aws_s3_bucket_public_access_block" "public_website" {
  bucket = aws_s3_bucket.public_website.id

  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false
}

resource "aws_s3_bucket_policy" "public_website" {
  bucket = aws_s3_bucket.public_website.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid       = "PublicRead"
        Effect    = "Allow"
        Principal = "*"
        Action    = "s3:GetObject"
        Resource  = "${aws_s3_bucket.public_website.arn}/*"
      }
    ]
  })
}

resource "aws_s3_bucket_server_side_encryption_configuration" "public_website" {
  bucket = aws_s3_bucket.public_website.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

resource "aws_s3_object" "index_html" {
  bucket       = aws_s3_bucket.public_website.id
  key          = "index.html"
  content_type = "text/html"

  content = <<EOF
<html>
  <head><title>Public Demo</title></head>
  <body>
    <h1>I Love Coffee! :-) </h1>
    <img src="coffee.png" alt="Logo" />
    <p>Terraform-managed content</p>
  </body>
</html>
EOF
}

resource "aws_s3_object" "coffee_png" {
  bucket       = aws_s3_bucket.public_website.id
  key          = "coffee.png"
  source       = "${path.module}/assets/coffee.png"   
  content_type = "image/png"
  etag         = filemd5("${path.module}/assets/coffee.png")
}


# -------------------------------------------------------------------

resource "aws_s3_bucket" "internal_logs" {
  bucket = "my-internal-logs-demo"

  tags = {
    environment = "prod"
    public_facing = "false"
    data_class  = "restricted"
    managed_by  = "terraform"
  }
}

resource "aws_s3_bucket_public_access_block" "internal_logs" {
  bucket = aws_s3_bucket.internal_logs.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}
