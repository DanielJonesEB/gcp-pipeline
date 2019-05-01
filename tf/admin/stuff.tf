data "google_organization" "org" {
  domain = "engineerbetter.com"
}

data "google_active_folder" "spikes" {
  display_name = "spikes"
  parent       = "${data.google_organization.org.name}"
}

resource "google_project" "my_project" {
  name       = "GCP Spike"
  project_id = "dj190501-a"
  folder_id  = "${data.google_active_folder.spikes.name}"
}
