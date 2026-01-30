terraform {
  backend "s3" {
    bucket         = "526053389648-terraform-state-bucket"
    key            = "lab/noncompliant/terraform.tfstate"
    region         = "eu-west-2"
    dynamodb_table = "terraform-state"
    encrypt        = true
  }
}
