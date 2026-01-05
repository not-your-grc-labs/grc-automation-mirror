terraform {
  backend "s3" {
    bucket         = "526053389648-terraform-state-bucket"
    key            = "lab/terraform.tfstate"
    region         = "eu-west-2"
    use_lockfile = "terraform-state"
    encrypt        = true
    
  }
}