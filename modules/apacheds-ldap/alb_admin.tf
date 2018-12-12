# Admin ELB

resource "aws_lb" "admin" {
  name               = "${var.short_environment_name}-${var.tier_name}-admin"
  load_balancer_type = "network"
  internal           = true
  ip_address_type    = "ipv4"
  security_groups    = ["${var.admin_elb_sg_id}"]
  subnets            = ["${var.private_subnets}"]
  tags               = "${merge(var.tags, map("Name", "${var.environment_name}-${var.tier_name}-admin"))}"
}

resource "aws_lb_target_group" "admin" {
  port        = "${var.admin_port}"
  protocol    = "TCP"
  vpc_id      = "${var.vpc_id}"
  tags        = "${merge(var.tags, map("Name", "${var.environment_name}-${var.tier_name}-admin"))}"
  stickiness  = []

  health_check {
  }
}

resource "aws_lb_target_group_attachment" "admin" {
  port             = "${var.admin_port}"
  target_group_arn = "${aws_lb_target_group.admin.arn}"
  target_id        = "${aws_instance.ldap.id}"
}

resource "aws_lb_listener" "admin" {
  "default_action" {
    target_group_arn = "${aws_lb_target_group.admin.arn}"
    type             = "forward"
  }

  load_balancer_arn = "${aws_lb.admin.arn}"
  port              = "${var.admin_port}"
}

resource "aws_route53_record" "admin_lb_internal" {
  zone_id = "${var.private_zone_id}"
  name    = "${var.tier_name}-admin"
  type    = "CNAME"
  ttl     = "300"
  records = ["${aws_lb.admin.dns_name}"]
}

resource "aws_route53_record" "admin_lb_public" {
  zone_id = "${var.public_zone_id}"
  name    = "${var.tier_name}-admin"
  type    = "CNAME"
  ttl     = "300"
  records = ["${aws_lb.admin.dns_name}"]
}

output "internal_fqdn_admin_lb" {
  value = "${aws_route53_record.admin_lb_internal.fqdn}"
}

output "public_fqdn_admin_lb" {
  value = "${aws_route53_record.admin_lb_public.fqdn}"
}
