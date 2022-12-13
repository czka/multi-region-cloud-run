resource "google_cloud_run_service" "run_default" {
#  provider = google-beta
  #TODO: Switch to for_each?
  count    = length(var.cloudrun_regions)
  name     = "cloudrun-app-${var.cloudrun_regions[count.index]}"
  location = var.cloudrun_regions[count.index]

  template {
    spec {
      containers {
        image = var.cloudrun_image
      }
    }
  }

  traffic {
    percent         = 100
    latest_revision = true
  }

  # Use an explicit depends_on clause to wait until API is enabled
  depends_on = [
    google_project_service.run_api
  ]
}

resource "google_cloud_run_service_iam_member" "run_allow_unauthenticated" {
#  provider = google-beta
  count    = length(var.cloudrun_regions)
  location = google_cloud_run_service.run_default[count.index].location
  service  = google_cloud_run_service.run_default[count.index].name
  role     = "roles/run.invoker"
  member   = "allUsers"
}
