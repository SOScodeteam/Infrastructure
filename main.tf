variable "github_token" {
  type = string
}

variable "teams" {}
variable "members" {}
variable "repos" {}

locals {
  team_assignments = flatten([
    for tm, mbrs in var.teams : [
      for mbr in mbrs : {
        team   = tm,
        member = mbr
      }
    ]
  ])
  repo_assignments = flatten([
    for repo, tms in var.repos : [
      for tm in tms : {
        repo = repo,
        team = tm
      }
    ]
  ])
}

provider "github" {
  token        = var.github_token
  organization = "soscodeteam"
}

resource "github_membership" "members" {
  for_each = toset(var.members)
  username = each.key
  role     = "member"
}

resource "github_team" "teams" {
  for_each = var.teams
  name     = each.key
  privacy  = "closed"
}

resource "github_team_membership" "team_memberships" {
  count    = length(local.team_assignments)
  team_id  = github_team.teams[local.team_assignments[count.index].team].id
  username = local.team_assignments[count.index].member
}

resource "github_repository" "repositories" {
  for_each      = var.repos
  name          = each.key
  private       = false
  has_issues    = true
  has_downloads = true
  has_projects  = true
  has_wiki      = true
}

resource "github_team_repository" "repository_teams" {
  count      = length(local.repo_assignments)
  team_id    = github_team.teams[local.repo_assignments[count.index].team].id
  repository = local.repo_assignments[count.index].repo
  permission = "push"
}

resource "github_branch_protection" "branch_protections" {
  for_each       = var.repos
  repository     = each.key
  branch         = "master"
  enforce_admins = true
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