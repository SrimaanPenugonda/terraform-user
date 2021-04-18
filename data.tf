data "terraform_remote_state" "alb" {
  backend        = "s3"
  config         = {
    bucket       = var.bucket //existing bucket name to access VPC state files
    key          = "alb/${var.ENV}/terraform.tfstate" //path in bucket
    region       = var.region
  }
}