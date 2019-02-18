terraform {
  backend "s3" {
    bucket = "your_s3_bucket"
    key    = "environment"
    region = "us-east-1"
  }
}