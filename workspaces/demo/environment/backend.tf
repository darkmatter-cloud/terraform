terraform {
  backend "s3" {
    bucket = "darkmatter-terraform"
    key    = "environment"
    region = "us-east-1"
  }
}
