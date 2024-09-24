terraform {
  backend "s3" {
    key    = "states/dotlanche-authentication"
    region = "us-east-1"
  }
}