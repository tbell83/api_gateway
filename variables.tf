variable "lambda_invoke_arn" {
  description = "The ARN to be used for invoking Lambda Function from API Gateway."
  type        = string
}

variable "policy" {
  description = "JSON formatted policy document that controls access to the API Gateway"
  default     = ""
}

variable "http_method" {
  description = "The HTTP Method (GET, POST, PUT, DELETE, HEAD, OPTIONS, ANY)"
  type        = string
}

variable "authorization" {
  description = "The type of authorization used for the method (NONE, CUSTOM, AWS_IAM)"
  type        = string
}

variable "integration_http_method" {
  description = "The integration HTTP method (GET, POST, PUT, DELETE, HEAD, OPTION) specifying how API Gateway will interact with the back end. Required if type is AWS, AWS_PROXY, HTTP or HTTP_PROXY."
  type        = string
  default     = "POST"
}

variable "type" {
  description = "The integration input's type. Valid values are HTTP (for HTTP backends), MOCK (not calling any real backend), AWS (for AWS services), AWS_PROXY (for Lambda proxy integration) and HTTP_PROXY (for HTTP proxy integration)."
  type        = string
}

variable "name" {
  description = "Name prefix for module resources."
  type        = string
}

variable "mod_count" {
  default = 1
}

variable "tags" {
  description = "tags"
  type        = map(string)
}

variable "stage_name" {
  description = "The name of the stage for the `aws_api_gateway_deployment` resource."
  type        = string
}

variable "acm_domain" {
  description = "The domain of the certificate to look up. If no certificate is found with this name, an error will be returned."
  type        = string
  default     = ""
}

variable "fqdn" {
  type    = string
  default = ""
}
