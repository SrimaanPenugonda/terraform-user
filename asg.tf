module "asg" {
  source          = "git::https://github.com/SrimaanPenugonda/terraform-asg.git"
  COMPONENT       = var.COMPONENT
  ENV             = var.ENV
  INSTANCE_TYPE   = var.INSTANCE_TYPE
  bucket          = var.bucket //pass the bucket name to access the VPC state file
  region          = var.region
  PORT            = 8080
  HEALTH          = "/health"
} // calling other module(terraform-asg) as asg module also pass the variables to it.

resource "aws_lb_listener_rule" "catalogue" {
  listener_arn        = data.terraform_remote_state.alb.outputs.PRIVATE_ALB_LISTENER_ARN
  action {
    type              = "forward"
    target_group_arn  = module.asg.TG_ARN
  }
  condition {
    host_header {
      values          = ["${var.COMPONENT}-${var.ENV}.devopssri.ml"]
    }
  }
}
resource "aws_route53_record" "alb" {
  zone_id             = "Z02790743IF4OLO4KMMFA"
  name                = "${var.COMPONENT}-${var.ENV}.devopssri.ml"
  type                = "CNAME"
  ttl                 = "300"
  records             = [data.terraform_remote_state.alb.outputs.PRIVATE_ALB_DNS]
}
