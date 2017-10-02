# Code Sample for "Continuously Deployed Infrastructure: How & Why" DDD By Night Talk

This repo contains the sample project discussed in my DDD By Night talk, which is a basic "Hello World" website hosted in S3.
The key thing is that rather than creating the S3 bucket yourself, it will be automatically created by the Travis build configured in .travis.yml.
This establishes the basis for any project looking to integrate their infrastructure rollout into their continuous deployment process.

It contains:
 - A simple "Hello World" HTML page
 - [Terraform](https://www.terraform.io/) configuration to create an S3 bucket configured as a website
 - Configuration for [Travis CI](https://docs.travis-ci.com/) to roll out the Terraform infrastructure and then deploy the HTML file to it

## Using this repo

You can fork this repo to see the example running with your own eyes with your own infrastructure!

### Pre-requisites:
 - An AWS account (and at least some basic AWS knowledge, preferably)
 - GitHub account
 - Have Travis CI authenticated with your GitHub account (in order to build your fork on Travis)
 
### 1. Fork This Repo

### 2. Configure Terraform Backend

This is necessary in order for Travis to "remember" what your infrastructure looks like between each build, so it knows what changes to make.

On line 25 of terraform.tf, set the "bucket" attribute to the name of an S3 bucket in your account to store your Terraform state files.
Create a new bucket if you need to.

### 3. Set The Name For Your Website Bucket

For example "hello-world.com" is the fake website name I use in my configuration. Since this example won't be creating any DNS records 
for the website, the actual name doesn't matter, but since S3 requires that your bucket name be globally unique, 
you need to set it to something of your own.

You'll need to update line 13 of terraform.tf to use the name you choose, as well as line 27 of .travis.yml so Travis knows which bucket to deploy to.

### 4. Enable Travis Builds for the Repo

Just know that if you try to trigger any builds before completing the next step, they will fail due to lack of AWS access.

### 4. Configure the Repo in Travis with AWS credentials

In order to be able to access your AWS account (both for creating the S3 bucket and deploying to it), the Travis configuration expects
two environment variables to be present: AWS_ACCESS_KEY_ID and AWS_SECRET_ACCESS_KEY.

You can use either the Access/Secret Keys for your root AWS account or any IAM user you've created, so long as it has permissions 
for S3 it should work just fine!

### 5. Run a Build!

Commit something to your repo in order to trigger off a Travis build for the repo. If you've configured everything correctly,
it should create an S3 bucket of the name you chose, and upload the website files to it! Woohoo!

Note that at the end of the "terraform apply" command in your Travis build logs, Terraform should have output the URL for your website.
If you access that URL you should see our glorious Hello World page!
