provider "google" {
  billing_project       = var.billing_project
  user_project_override = true
}

data "google_organization" "default" {
  domain = var.organization_domain
}

locals {
  groups = {
    "gcp-billing-admins"      = "Billing Admins"
    "gcp-devops"              = "DevOps"
    "gcp-network-admins"      = "Network Admins"
    "gcp-organization-admins" = "Organization Admins"
    "gcp-security-admins"     = "Security Admins"
  }
}

resource "google_cloud_identity_group" "basic" {
  for_each     = local.groups
  display_name = each.value

  parent = "customers/${data.google_organization.default.directory_customer_id}"

  group_key {
    id = "${each.key}@${var.organization_domain}"
  }

  labels = {
    "cloudidentity.googleapis.com/groups.discussion_forum" = ""
    "cloudidentity.googleapis.com/groups.security"         = ""
  }
}
