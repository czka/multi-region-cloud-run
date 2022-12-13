resource "google_project_service" "compute_api" {
#  provider                   = google-beta
  service                    = "compute.googleapis.com"
  disable_dependent_services = false
  disable_on_destroy         = true
}

resource "google_project_service" "run_api" {
#  provider                   = google-beta
  service                    = "run.googleapis.com"
  disable_dependent_services = false
  disable_on_destroy         = true
}
