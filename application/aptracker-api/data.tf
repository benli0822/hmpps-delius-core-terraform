data "terraform_remote_state" "vpc" {
  backend = "s3"
  config {
    bucket = "${var.remote_state_bucket_name}"
    key    = "vpc/terraform.tfstate"
    region = "${var.region}"
  }
}

data "terraform_remote_state" "vpc_security_groups" {
  backend = "s3"
  config {
    bucket = "${var.remote_state_bucket_name}"
    key    = "security-groups/terraform.tfstate"
    region = "${var.region}"
  }
}

data "terraform_remote_state" "delius_core_security_groups" {
  backend = "s3"
  config {
    bucket = "${var.remote_state_bucket_name}"
    key    = "delius-core/security-groups/terraform.tfstate"
    region = "${var.region}"
  }
}

data "terraform_remote_state" "key_profile" {
  backend = "s3"
  config {
    bucket = "${var.remote_state_bucket_name}"
    key    = "delius-core/key_profile/terraform.tfstate"
    region = "${var.region}"
  }
}

data "terraform_remote_state" "s3buckets" {
  backend = "s3"
  config {
    bucket = "${var.remote_state_bucket_name}"
    key    = "delius-core/s3buckets/terraform.tfstate"
    region = "${var.region}"
  }
}

data "terraform_remote_state" "ldap" {
  backend = "s3"
  config {
    bucket = "${var.remote_state_bucket_name}"
    key    = "delius-core/application/ldap/terraform.tfstate"
    region = "${var.region}"
  }
}

data "terraform_remote_state" "database" {
  backend = "s3"
  config {
    bucket = "${var.remote_state_bucket_name}"
    key    = "delius-core/database_failover/terraform.tfstate"
    region = "${var.region}"
  }
}

data "terraform_remote_state" "ecs_cluster" {
  backend = "s3"
  config {
    bucket = "${var.remote_state_bucket_name}"
    key    = "ecs-cluster/terraform.tfstate"
    region = "${var.region}"
  }
}

data "terraform_remote_state" "ndelius" {
  backend = "s3"
  config {
    bucket = "${var.remote_state_bucket_name}"
    key    = "delius-core/application/ndelius/terraform.tfstate"
    region = "${var.region}"
  }
}

data "terraform_remote_state" "interface" {
  backend = "s3"
  config {
    bucket = "${var.remote_state_bucket_name}"
    key    = "delius-core/application/interface/terraform.tfstate"
    region = "${var.region}"
  }
}

data "terraform_remote_state" "spg" {
  backend = "s3"
  config {
    bucket = "${var.remote_state_bucket_name}"
    key    = "delius-core/application/spg/terraform.tfstate"
    region = "${var.region}"
  }
}

data "aws_route53_zone" "public" {
  zone_id = "${data.terraform_remote_state.vpc.public_zone_id}"
}

data "aws_route53_zone" "private" {
  zone_id = "${data.terraform_remote_state.vpc.private_zone_id}"
}

data "aws_acm_certificate" "cert" {
  domain      = "${data.terraform_remote_state.vpc.public_ssl_domain}"
  types       = ["AMAZON_ISSUED"]
  most_recent = true
}

data "aws_caller_identity" "current" {}

data "aws_ami" "ecs_ami" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["amzn-ami-*-amazon-ecs-optimized"]
  }
}

data "template_file" "ecs_assume_role_policy_template" {
  template = "${file("${path.module}/templates/iam/ecs_assume_role_policy.json.tpl")}"
  vars {}
}

data "template_file" "ecs_exec_policy_template" {
  template = "${file("${path.module}/templates/iam/ecs_exec_policy.json.tpl")}"
  vars {
    aws_account_id   = "${data.aws_caller_identity.current.account_id}"
    region           = "${var.region}"
    environment_name = "${var.environment_name}"
    project_name     = "${var.project_name}"
  }
}

data "template_file" "container_definition" {
  template = "${file("templates/ecs/container_definition.json.tpl")}"
  vars {
    region           = "${var.region}"
    aws_account_id   = "${data.aws_caller_identity.current.account_id}"
    environment_name = "${var.environment_name}"
    project_name     = "${var.project_name}"

    container_name  = "${local.app_name}"
    image_url       = "${local.image_url}"
    image_version   = "${local.aptracker_api_config["version"]}"
    log_group_name  = "${var.environment_name}/${local.app_name}"
    memory          = "${local.aptracker_api_config["memory"]}"
    cpu             = "${local.aptracker_api_config["cpu"]}"

    log_group_name    = "${var.environment_name}/${local.app_name}"
    log_level         = "${local.aptracker_api_config["log_level"]}"

    database_url      = "${data.terraform_remote_state.database.jdbc_failover_url}"
    database_username = "delius_app_schema"
    oauth_token_uri   = "https://${data.terraform_remote_state.ndelius.public_fqdn_ndelius_wls_external}/umt/oauth/check_token"
  }
}
