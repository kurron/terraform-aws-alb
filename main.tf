terraform {
    required_version = ">= 0.10.7"
    backend "s3" {}
}

provider "aws" {
    region     = "${var.region}"
}

resource "aws_s3_bucket" "access_logs" {
    bucket_prefix = "access-logs-"
    acl           = "private"
    force_destroy = "true"
    region        = "${var.region}"
    tags {
        Name        = "${var.name}"
        Project     = "${var.project}"
        Purpose     = "Holds HTTP access logs for project ${var.project}"
        Creator     = "${var.creator}"
        Environment = "${var.environment}"
        Freetext    = "${var.freetext}"
    }
    lifecycle_rule {
        id = "log-expiration"
        enabled = "true"
        expiration {
            days = "7"
        }
        tags {
            Name        = "${var.name}"
            Project     = "${var.project}"
            Purpose     = "Expire access logs for project ${var.project}"
            Creator     = "${var.creator}"
            Environment = "${var.environment}"
            Freetext    = "${var.freetext}"
        }
    }
}

data "aws_elb_service_account" "main" {}

data "aws_billing_service_account" "main" {}

data "template_file" "alb_permissions" {
    template = "${file("${path.module}/files/permissions.json.template")}"
    vars {
        bucket_name     = "${aws_s3_bucket.access_logs.id}"
        billing_account = "${data.aws_billing_service_account.main.id}"
        service_account = "${data.aws_elb_service_account.main.arn}"
    }
}

resource "aws_s3_bucket_policy" "alb_permissions" {
    bucket = "${aws_s3_bucket.access_logs.id}"
    policy = "${data.template_file.alb_permissions.rendered}"
}

resource "aws_lb" "alb" {
    name_prefix                = "alb-"
    internal                   = "${var.internal == "Yes" ? true : false}"
    load_balancer_type         = "application"
    security_groups            = ["${var.security_group_ids}"]
    subnets                    = ["${var.subnet_ids}"]
    idle_timeout               = 60
    enable_deletion_protection = false
    ip_address_type            = "ipv4"
    tags {
        Name        = "${var.name}"
        Project     = "${var.project}"
        Purpose     = "${var.purpose}"
        Creator     = "${var.creator}"
        Environment = "${var.environment}"
        Freetext    = "${var.freetext}"
    }
    timeouts {
        create = "10m"
        update = "10m"
        delete = "10m"
    }
#    access_logs {
#        bucket  = "${aws_s3_bucket.access_logs.id}"
#        enabled = "false"
#    }
}
