variable "creds_json" {}

provider "google" {
  credentials = "${var.creds_json}"
}

data "google_organization" "org" {
  domain = "engineerbetter.com"
}

data "google_active_folder" "spikes" {
  display_name = "spikes"
  parent       = "organizations/${data.google_organization.org.number}"
}

resource "google_project" "my_project" {
  name       = "GCP Spike"
  project_id = "dj190501-a"
  folder_id  = "${data.google_active_folder.spikes.name}"
}

resource "google_storage_bucket" "ci" {
  name     = "dj190501-a"
  location = "EU"
  project  = "${google_project.my_project.project_id}"

  versioning {
    enabled = true
  }
}
