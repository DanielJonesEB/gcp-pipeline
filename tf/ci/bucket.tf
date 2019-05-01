resource "google_storage_bucket" "ci" {
  name     = "dj190501-a"
  location = "EU"

  versioning {
    enabled = true
  }
}
