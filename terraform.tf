#We'll be deploying into the Sydney region of AWS.
provider "aws" {
  region = "ap-southeast-2"
}

variable "website_name" {
    type = "string"
    description = "Name of the S3 bucket and website to create, e.g. 'hello-world.com'"

    #####################################
    #IMPORTANT: Set this to the name you want for the S3 bucket that our terraform will create!
    #####################################
    default = "hello-world.com"
}

terraform {
  backend "s3" {
    key    = "ddd-by-night-oct-2017/terraform.tfstate"
    region = "ap-southeast-2"
    
    #####################################
    #IMPORTANT: Set this to the name of an EXISTING S3 bucket in your AWS account.
    #Terraform will use this to store information about your infrastructure so it knows what to create/update/delete when you apply changes.
    #####################################
    bucket = "chrislewisdev-terraform"
  }
}

#The file 's3-website-policy.json' contains a boilerplate public-access policy for our website bucket.
#This template_file block inserts our website name into the policy so we can use it when creating our bucket.
data "template_file" "s3_website_policy" {
  template = "${file("s3-website-policy.json")}"

  vars {
    bucket_name = "${var.website_name}"
  }
}

#This creates our bucket with a public access policy and minimal website config.
resource "aws_s3_bucket" "website_bucket" {
  bucket = "${var.website_name}"
  acl    = "public-read"
  policy = "${data.template_file.s3_website_policy.rendered}"

  website {
    index_document = "index.html"
  }
}

#Once terraform has completed, it will display the value of this output variable.
#You can access this URL to see your deployed website!
output "website_url" {
  value = "${aws_s3_bucket.website_bucket.website_endpoint}"
}