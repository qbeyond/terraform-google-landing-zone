# Overview
This is a Terraform module that returns a `providers.tf.tpl` with 2 variables: `bucket_name` and `service_account`.

The `output.tf` file contains the output "content" with the value of the template file `./providers.tf.tpl`, using the `bucket_name` and `service_account` variables.

This module is useful for configuring a remote state in Google Storage Buckets.

Note that this is a Terraform template file, and you will need to use Terraform's template rendering functionality to use it.


<!-- BEGIN_TF_DOCS -->

<!-- END_TF_DOCS -->