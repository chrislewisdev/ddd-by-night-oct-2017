provider "aws" {
  region = "ap-southeast-2"
}

variable "website_name" {
    type = "string"
    default = "hello-world.com"
}

terraform {
  backend "s3" {
    bucket = "chrislewisdev-terraform"
    key    = "ddd-by-night-oct-2017/terraform.tfstate"
    region = "ap-southeast-2"
  }
}

data "template_file" "s3_website_policy" {
  template = "{$file("s3-website-policy.json")}"

  vars {
    bucket_name = "${var.website_name}"
  }
}

resource "aws_s3_bucket" "website_bucket" {
  bucket = "${var.website_name}"
  acl    = "public-read"
  policy = "${data.template_file.s3_website_policy.rendered}"

  website {
    index_document = "index.html"
  }
}

output "website_url" {
  value = "${aws_s3_bucket.website_bucket.website_endpoint}"
}