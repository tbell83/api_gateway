resource "aws_api_gateway_rest_api" "apigw" {
  name = "${var.name}"
}

resource "aws_api_gateway_resource" "proxy" {
  rest_api_id = "${aws_api_gateway_rest_api.apigw.id}"
  parent_id   = "${aws_api_gateway_rest_api.apigw.root_resource_id}"
  path_part   = "{proxy+}"
}

resource "aws_api_gateway_method" "proxy" {
  rest_api_id   = "${aws_api_gateway_rest_api.apigw.id}"
  resource_id   = "${aws_api_gateway_resource.proxy.id}"
  http_method   = "${var.http_method}"
  authorization = "${var.authorization}"
}

resource "aws_api_gateway_method" "proxy_root" {
  rest_api_id   = "${aws_api_gateway_rest_api.apigw.id}"
  resource_id   = "${aws_api_gateway_rest_api.apigw.root_resource_id}"
  http_method   = "${var.http_method}"
  authorization = "${var.authorization}"
}

resource "aws_api_gateway_integration" "lambda_root" {
  rest_api_id = "${aws_api_gateway_rest_api.apigw.id}"
  resource_id = "${aws_api_gateway_method.proxy_root.resource_id}"
  http_method = "${aws_api_gateway_method.proxy_root.http_method}"

  integration_http_method = "${var.integration_http_method}"
  type                    = "${var.type}"
  uri                     = "${var.lambda_invoke_arn}"
}

resource "aws_api_gateway_integration" "lambda" {
  rest_api_id = "${aws_api_gateway_rest_api.apigw.id}"
  resource_id = "${aws_api_gateway_method.proxy.resource_id}"
  http_method = "${aws_api_gateway_method.proxy.http_method}"

  integration_http_method = "${var.integration_http_method}"
  type                    = "${var.type}"
  uri                     = "${var.lambda_invoke_arn}"
}

resource "aws_api_gateway_deployment" "apigw" {
  depends_on = [
    "aws_api_gateway_integration.lambda",
    "aws_api_gateway_integration.lambda_root",
  ]

  rest_api_id = "${aws_api_gateway_rest_api.apigw.id}"
  stage_name  = "${var.stage_name}"
}
