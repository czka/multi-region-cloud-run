resource "google_project_service" "compute_api" {
  service                    = "compute.googleapis.com"
  disable_dependent_services = false
  disable_on_destroy         = true
}

resource "google_project_service" "run_api" {
  service                    = "run.googleapis.com"
  disable_dependent_services = false
  disable_on_destroy         = true
}
