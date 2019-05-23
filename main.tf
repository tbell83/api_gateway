resource "aws_api_gateway_rest_api" "apigw" {
  count = "${var.mod_count}"

  name   = "${var.name}"
  policy = "${var.policy}"
}

resource "aws_api_gateway_resource" "proxy" {
  count = "${var.mod_count}"

  rest_api_id = "${aws_api_gateway_rest_api.apigw.id}"
  parent_id   = "${aws_api_gateway_rest_api.apigw.root_resource_id}"
  path_part   = "{proxy+}"
}

resource "aws_api_gateway_method" "proxy" {
  count = "${var.mod_count}"

  rest_api_id   = "${aws_api_gateway_rest_api.apigw.id}"
  resource_id   = "${aws_api_gateway_resource.proxy.id}"
  http_method   = "${var.http_method}"
  authorization = "${var.authorization}"
}

resource "aws_api_gateway_method" "proxy_root" {
  count = "${var.mod_count}"

  rest_api_id   = "${aws_api_gateway_rest_api.apigw.id}"
  resource_id   = "${aws_api_gateway_rest_api.apigw.root_resource_id}"
  http_method   = "${var.http_method}"
  authorization = "${var.authorization}"
}

resource "aws_api_gateway_integration" "lambda_root" {
  count = "${var.mod_count}"

  rest_api_id = "${aws_api_gateway_rest_api.apigw.id}"
  resource_id = "${aws_api_gateway_method.proxy_root.resource_id}"
  http_method = "${aws_api_gateway_method.proxy_root.http_method}"

  integration_http_method = "${var.integration_http_method}"
  type                    = "${var.type}"
  uri                     = "${var.lambda_invoke_arn}"
}

resource "aws_api_gateway_integration" "lambda" {
  count = "${var.mod_count}"

  rest_api_id = "${aws_api_gateway_rest_api.apigw.id}"
  resource_id = "${aws_api_gateway_method.proxy.resource_id}"
  http_method = "${aws_api_gateway_method.proxy.http_method}"

  integration_http_method = "${var.integration_http_method}"
  type                    = "${var.type}"
  uri                     = "${var.lambda_invoke_arn}"
}

resource "aws_api_gateway_deployment" "apigw" {
  count = "${var.mod_count}"

  depends_on = [
    "aws_api_gateway_integration.lambda",
    "aws_api_gateway_integration.lambda_root",
  ]

  rest_api_id = "${aws_api_gateway_rest_api.apigw.id}"
  stage_name  = "${var.stage_name}"
}

resource "aws_api_gateway_domain_name" "domain" {
  count = "${var.mod_count != 0 && var.acm_domain != "" ? 1 : 0}"

  domain_name     = "${var.fqdn}"
  certificate_arn = "${data.aws_acm_certificate.certificate.arn}"
}

data "aws_acm_certificate" "certificate" {
  count       = "${var.mod_count != 0 && var.acm_domain != "" ? 1 : 0}"
  domain      = "${var.acm_domain}"
  most_recent = true
}

resource "aws_api_gateway_base_path_mapping" "test" {
  count       = "${var.mod_count != 0 && var.acm_domain != "" ? 1 : 0}"
  api_id      = "${aws_api_gateway_rest_api.apigw.id}"
  stage_name  = "${aws_api_gateway_deployment.apigw.stage_name}"
  domain_name = "${aws_api_gateway_domain_name.domain.domain_name}"
}
