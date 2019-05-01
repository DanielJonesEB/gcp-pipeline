variable "creds_json" {}
variable "name" {}

provider "google" {
  credentials = "${var.creds_json}"
}

data "google_organization" "org" {
  domain = "engineerbetter.com"
}

data "google_billing_account" "acct" {
  display_name = "EngineerBetter"
  open         = true
}

data "google_active_folder" "spikes" {
  display_name = "spikes"
  parent       = "organizations/${data.google_organization.org.id}"
}

resource "google_project" "my_project" {
  name            = "GCP Spike"
  project_id      = "${var.name}"
  folder_id       = "${data.google_active_folder.spikes.name}"
  billing_account = "${data.google_billing_account.acct.id}"
}

resource "google_storage_bucket" "ci" {
  name     = "${var.name}"
  location = "EU"
  project  = "${google_project.my_project.project_id}"

  versioning {
    enabled = true
  }
}
