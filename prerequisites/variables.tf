variable "organization_id" {
  description = "Customer ID of the workspace."
  type        = string
}

variable "domain" {
  description = "Pimary domain of the organization."
  type        = string
}

variable "billing_project" {
  description = "Project to use for billing purposes"
  type        = string
}
