provider "aws" {
  region = "ap-southeast-2"
}

variable "website_name" {
    type = "string"
    default = "hello-world.com"
}

resource "aws_s3_bucket" "website_bucket" {
  bucket = "${var.website_name}"
  acl    = "public-read"
  policy = "${replace(file("s3-website-policy.json"), "BUCKET_NAME", "${var.website_name}")}"

  website {
    index_document = "index.html"
  }
}

output "website_url" {
  value = "${aws_s3_bucket.website_bucket.website_endpoint}"
}