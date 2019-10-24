data "terraform_remote_state" "alb" {
  backend = "s3"

  config = {
    region = var.alb_state_region
    bucket = var.alb_bucket
    key    = var.alb_state_key
  }
}