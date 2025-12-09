terraform {
  backend "s3" {
    bucket        = "terraform-state-backend-new"
    key           = "three-tier-demo"
    region        = "us-east-1"
    use_lockfile  = true
    encrypt       = true
  }
}
