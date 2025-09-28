variable "team_emails" {
  description = "List of team member email addresses for notifications"
  type        = list(string)
  default     = ["team1@example.com", "team2@example.com"]
}

variable "project_name" {
  description = "Name of the project for resource naming"
  type        = string
  default     = "serverless-tasks-alerts"
}