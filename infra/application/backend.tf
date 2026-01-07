terraform {
  backend "s3" {
    bucket = "cicd-artifacts-552516487395-test"  
    key    = "terraform/application/terraform.tfstate"
    region = "us-east-1" 
  }
}