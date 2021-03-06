output "private_fqdn_jms_broker" {
  value = "${aws_route53_record.jms_private.fqdn}"
}

output "public_fqdn_jms_broker" {
  value = "${aws_route53_record.jms_public.fqdn}"
}

output "private_fqdn_spg_wls_internal_alb" {
  value = "${module.spg.private_fqdn_internal_alb}"
}

output "cloudwatch_log_group" {
  value = "${module.spg.cloudwatch_log_group}"
}

output "asg" {
  value = "${module.spg.asg}"
}

output "alb" {
  value = "${module.spg.alb}"
}

output "weblogic_targetgroup" {
  value = "${module.spg.weblogic_targetgroup}"
}

output "jms_lb" {
  value = {
    "id"    = "${aws_elb.jms_lb.id}",
    "arn"   = "${aws_elb.jms_lb.arn}",
    "name"  = "${aws_elb.jms_lb.name}",
  }
}

output "ami_spg_wls" {
  value = "${data.aws_ami.centos_wls.id} - ${data.aws_ami.centos_wls.name}"
}

output "newtech_webfrontend_target_group_arn" {
  value = "${module.spg.newtech_webfrontend_targetgroup_arn}"
}

output "umt_targetgroup_arn" {
  value = "${module.spg.umt_targetgroup_arn}"
}

output "aptracker_api_targetgroup_arn" {
  value = "${module.spg.aptracker_api_targetgroup_arn}"
}

output "gdpr_api_targetgroup_arn" {
  value = "${module.spg.gdpr_api_targetgroup_arn}"
}

output "gdpr_ui_targetgroup_arn" {
  value = "${module.spg.gdpr_ui_targetgroup_arn}"
}
