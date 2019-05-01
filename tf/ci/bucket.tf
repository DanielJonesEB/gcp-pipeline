variable "creds_json" {}

provider "google" {
  credentials = "${var.creds_json}"
}

resource "google_storage_bucket" "ci" {
  name     = "dj190501-a"
  location = "EU"

  versioning {
    enabled = true
  }
}
