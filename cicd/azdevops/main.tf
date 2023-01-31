resource "azuredevops_git_repository" "bootstrap" {
  project_id = var.project_id
  name       = "Bootstrap"
  initialization {
    init_type = "Clean"
  }
}
