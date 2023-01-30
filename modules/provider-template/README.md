# Overview
This is a Terraform module that returns a `providers.tf.tpl` with 2 variables: `bucket_name` and `service_account`.

The `output.tf` file contains the output "content" with the value of the template file `./providers.tf.tpl`, using the `bucket_name` and `service_account` variables.

This module is useful for configuring a remote state in Google Storage Buckets.

Note that this is a Terraform template file, and you will need to use Terraform's template rendering functionality to use it.


<!-- BEGIN_TF_DOCS -->
## Usage

Basic Example
```hcl
resource "random_id" "testprefix" {
  byte_length = 5
}

module "gcs-provider" {
  source          = "../.."
  bucket_name     = "test${random_id.testprefix.hex}"
  service_account = var.service_account
}

variable "bucket_name" {
  description = "Bucket Name"
  type        = string
}

variable "service_account" {
  description = "service Account to create storage bucket with"
}
```

This returns a templatefile with the following structure

## Template File
The `providers.tf.tpl` file contains the following Terraform configuration:

```hcl
terraform {
backend "gcs" {
bucket                      = "${bucket_name}"
impersonate_service_account = "${service_account}"
}
}
provider "google" {
impersonate_service_account = "${service_account}"
}
provider "google-beta" {
impersonate_service_account = "${service_account}"
}
```

## Requirements

No requirements.

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_bucket_name"></a> [bucket\_name](#input\_bucket\_name) | Bucket Name | `string` | n/a | yes |
| <a name="input_service_account"></a> [service\_account](#input\_service\_account) | service Account to create storage bucket with | `any` | n/a | yes |
## Outputs

| Name | Description |
|------|-------------|
| <a name="output_content"></a> [content](#output\_content) | returns a provider config for a remote state in google storage buckets |
## Resource types

No resources.


## Modules

No modules.
## Resources by Files

No resources.

<!-- END_TF_DOCS -->