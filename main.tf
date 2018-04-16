resource "aws_api_gateway_rest_api" "apigw" {
  count = "${var.count}"

  name = "${var.name}"
}

resource "aws_api_gateway_resource" "proxy" {
  count = "${var.count}"

  rest_api_id = "${aws_api_gateway_rest_api.apigw.id}"
  parent_id   = "${aws_api_gateway_rest_api.apigw.root_resource_id}"
  path_part   = "{proxy+}"
}

resource "aws_api_gateway_method" "proxy" {
  count = "${var.count}"

  rest_api_id   = "${aws_api_gateway_rest_api.apigw.id}"
  resource_id   = "${aws_api_gateway_resource.proxy.id}"
  http_method   = "${var.http_method}"
  authorization = "${var.authorization}"
}

resource "aws_api_gateway_method" "proxy_root" {
  count = "${var.count}"

  rest_api_id   = "${aws_api_gateway_rest_api.apigw.id}"
  resource_id   = "${aws_api_gateway_rest_api.apigw.root_resource_id}"
  http_method   = "${var.http_method}"
  authorization = "${var.authorization}"
}

resource "aws_api_gateway_integration" "lambda_root" {
  count = "${var.count}"

  rest_api_id = "${aws_api_gateway_rest_api.apigw.id}"
  resource_id = "${aws_api_gateway_method.proxy_root.resource_id}"
  http_method = "${aws_api_gateway_method.proxy_root.http_method}"

  integration_http_method = "${var.integration_http_method}"
  type                    = "${var.type}"
  uri                     = "${var.lambda_invoke_arn}"
}

resource "aws_api_gateway_integration" "lambda" {
  count = "${var.count}"

  rest_api_id = "${aws_api_gateway_rest_api.apigw.id}"
  resource_id = "${aws_api_gateway_method.proxy.resource_id}"
  http_method = "${aws_api_gateway_method.proxy.http_method}"

  integration_http_method = "${var.integration_http_method}"
  type                    = "${var.type}"
  uri                     = "${var.lambda_invoke_arn}"
}

resource "aws_api_gateway_deployment" "apigw" {
  count = "${var.count}"

  depends_on = [
    "aws_api_gateway_integration.lambda",
    "aws_api_gateway_integration.lambda_root",
  ]

  rest_api_id = "${aws_api_gateway_rest_api.apigw.id}"
  stage_name  = "${var.stage_name}"
}

resource "aws_api_gateway_domain_name" "example" {
  count = "${var.count != 0 && var.acm_domain != "" ? 1 : 0}"

  domain_name     = "${var.name}${replace(data.aws_acm_certificate.certificate.domain, "*", "")}"
  certificate_arn = "${data.aws_acm_certificate.certificate.arn}"
}

data "aws_acm_certificate" "certificate" {
  count  = "${var.count != 0 && var.acm_domain != "" ? 1 : 0}"
  domain = "${var.acm_domain}"
}
