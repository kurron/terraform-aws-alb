output "alb_id" {
    value = "${aws_lb.alb.id}"
    description = "ID of the created ALB"
}

output "alb_arn" {
    value = "${aws_lb.alb.arn}"
    description = "ARN of the created ALB"
}

output "alb_arn_suffix" {
    value = "${aws_lb.alb.arn_suffix}"
    description = "The ARN suffix for use with CloudWatch Metrics."
}

output "alb_dns_name" {
    value = "${aws_lb.alb.dns_name}"
    description = "The DNS name of the load balancer."
}

output "alb_zone_id" {
    value = "${aws_lb.alb.zone_id}"
    description = "The canonical hosted zone ID of the load balancer (to be used in a Route 53 Alias record)."
}

output "secure_listener_arn" {
    value = "${aws_lb_listener.secure_listener.arn}"
    description = "ARN of the secure HTTP listener."
}

output "insecure_listener_arn" {
    value = "${aws_lb_listener.insecure_listener.arn}"
    description = "ARN of the insecure HTTP listener."
}
