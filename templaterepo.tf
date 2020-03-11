resource "github_repository" "template_repo" {
  name          = "OrgTemplate"
  private       = false
  has_issues    = true
  has_downloads = true
  has_projects  = true
  has_wiki      = true
}

resource "github_branch_protection" "template_protection" {
  repository     = github_repository.template_repo.name
  branch         = "master"
  enforce_admins = false
  required_status_checks {
    strict = true
  }
  required_pull_request_reviews {
    dismiss_stale_reviews           = true
    required_approving_review_count = 1
  }
  restrictions {
    users = []
    teams = []
  }
}