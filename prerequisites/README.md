# Required Groups Bootstrap
This Terraform module creates the necessary groups required by 00-bootstrap to run successfully. If you don't want to create the groups manually, you can use this module to automate the process.

## Prerequisites
Before using this module, you need to perform the following steps:

Login via gcloud auth application-default login.
Provide values for the following variables in your Terraform configuration:
billing_project: the ID of the billing project to associate with the resources created by this module.
organization_domain: the ID of the organization that will contain the groups created by this module.

## Usage
You can use this module in your Terraform configuration as follows:

```hcl
module "required_groups_bootstrap" {
  source = "path/to/required_groups_bootstrap"

  billing_project     = "my-billing-project"
  organization_domain = "test.customer.de"
}
```

## Module Variables
billing_project: (Required) The ID of the billing project to associate with the resources created by this module.
organization_domain: (Required) The domain name of the organization that will contain the groups created by this module.
