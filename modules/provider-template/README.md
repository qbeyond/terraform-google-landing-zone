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

## Requirements

No requirements.

## Inputs

No inputs.
## Outputs

No outputs.
## Resource types

No resources.


## Modules

No modules.
## Resources by Files

No resources.

<!-- END_TF_DOCS -->
## Usage

To use this module, add the following to your Terraform configuration:

```hcl
module "gcs_provider" {    
    source          = "path/to/module"
    bucket_name     = var.bucket_name
    service_account = var.service_account
    }
```

## Inputs

- `bucket_name`: The name of the Google Storage Bucket to use for the remote state.
- `service_account`: The service account to use for authentication.

## Outputs
- `content`: The content of the generated `providers.tf.tpl` file.

## Template File
The `providers.tf.tpl` file contains the following Terraform configuration:

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
Note that this is a Terraform template file, and you will need to use Terraform's template rendering functionality to use it.