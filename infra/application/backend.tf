terraform {
  backend "s3" {
    bucket = "terraform-state-552516487395-test" 
    key    = "application/terraform.tfstate"
    region = "us-east-1"
  }
}