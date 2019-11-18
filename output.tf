output "execution_arn" {
  value = aws_api_gateway_deployment.apigw.*.execution_arn
}

output "base_url" {
  value = aws_api_gateway_deployment.apigw.*.invoke_url
}

output "cloudfront_domain_name" {
  value = join(",", aws_api_gateway_domain_name.domain.*.cloudfront_domain_name)
}

output "cloudfront_zone_id" {
  value = join(",", aws_api_gateway_domain_name.domain.*.cloudfront_zone_id)
}
