output "execution_arn" {
  value = "${aws_api_gateway_deployment.apigw.*.execution_arn}"
}

output "base_url" {
  value = "${aws_api_gateway_deployment.apigw.*.invoke_url}"
}

output "cloudfront_domain_name" {
  value = "${aws_api_gateway_domain_name.domain.*.domain_name}"
}
