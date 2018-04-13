output "execution_arn" {
  count = "${var.count}"
  value = "${aws_api_gateway_deployment.apigw.*.execution_arn}"
}

output "base_url" {
  count = "${var.count}"
  value = "${aws_api_gateway_deployment.apigw.*.invoke_url}"
}
