terraform {
  backend "s3" {
    bucket = "soscodeteamtf"
    key    = "terraform/state"
    region = "us-east-1"
  }
}