variable "tier_name" {
  description = "Name of the Weblogic tier"
  type        = "string"
}

variable "ami_id" {
  description = "AWS AMI ID"
  type        = "string"
}

variable "instance_type" {
  description = "Instance type for the weblogic server"
  type        = "string"
}

variable "key_name" {
  description = "Deployer key name"
  type        = "string"
}

variable "iam_instance_profile" {
  description = "iam instance profile id"
  type        = "string"
}

variable "security_groups" {
  description = "Security groups for the admin server"
  type        = "list"
}

variable "public_subnets" {
  description = "Subnet for Managed load balancers"
  type        = "list"
}

variable "private_subnets" {
  description = "Subnet for Admin load balancers"
  type        = "list"
}

variable "tags" {
  description = "Tags to match tagging standard"
  type        = "map"
}

variable "environment_name" {
  description = "Name of the environment"
  type        = "string"
}

variable "short_environment_name" {
  description = "Shortend name of the environment"
  type        = "string"
}

variable "bastion_inventory" {
  description = "Bastion environment inventory"
  type        = "string"
}

variable "environment_identifier" {
  description = "resource label or name"
}

variable "short_environment_identifier" {
  description = "shortend resource label or name"
}

variable "environment_type" {
  description = "The environment type - e.g. dev"
}

variable "region" {
  description = "The AWS region."
}

variable "vpc_id" {
  description = "VPC ID"
  type        = "string"
}

variable "vpc_account_id" {
  description = "VPC Account ID"
  type        = "string"
}

variable "kms_key_id" {
  description = "ARN of KMS Key"
  type        = "string"
}

variable "public_zone_id" {
  description = "Public zone id"
  type        = "string"
}

variable "private_zone_id" {
  description = "Private internal zone id"
  type        = "string"
}

variable "private_domain" {
  description = "Private internal zone name"
  type        = "string"
}

variable "admin_elb_sg_id" {
  description = "ID for the security group for the ELB"
  type        = "string"
}

variable "managed_elb_sg_id" {
  description = "ID for the security group for the ELB"
  type        = "string"
}

variable "admin_port" {
  description = "TCP port for the admin server"
  type        = "string"
}

variable "managed_port" {
  description = "TCP port for the managed server"
  type        = "string"
}

variable "admin_health_check" {
  description = "parameters for the LB health check"
  type        = "map"
  default = {
    "path" = "/"
    "matcher" = "200"
  }
}

variable "managed_health_check" {
  description = "parameters for the LB health check"
  type        = "map"
  default = {
    "path" = "/"
    "matcher" = "200"
  }
}

variable "app_bootstrap_name" {
  description = "app bootstrap name"
  type        = "string"
}

variable "app_bootstrap_src" {
  description = "app bootstrap src"
  type        = "string"
}

variable "app_bootstrap_version" {
  description = "app bootstrap version"
  type        = "string"
}

variable "app_bootstrap_initial_role" {
  description = "app bootstrap initial role name (may be same as app_bootstrap_name)"
  type        = "string"
}

variable "app_bootstrap_secondary_role" {
  description = "app bootstrap supplementary role name (optional)"
  type        = "string"
  default     = "nada"
}

variable "app_bootstrap_tertiary_role" {
  description = "app bootstrap tertiary role name (optional)"
  type        = "string"
  default     = "nada"
}

variable "ndelius_version" {
  description = "NDelius version"
}

variable "ansible_vars" {
  description = "Ansible vars for user_data script"
  type        = "map"
}