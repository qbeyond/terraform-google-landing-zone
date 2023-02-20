provider "google" {
  billing_project       = "${var.billing_project}"
  user_project_override = true
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

resource "google_cloud_identity_group" "cloud_identity_group_basic" {
  for_each     = local.groups
  display_name = each.value

  parent = "customers/${var.organization_id}"

  group_key {
    id = "${each.key}@${var.domain}"
  }

  labels = {
    "cloudidentity.googleapis.com/groups.discussion_forum" = ""
    "cloudidentity.googleapis.com/groups.security"         = ""
  }
}
