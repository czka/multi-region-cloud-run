#TODO: Rename "run_default" resource to something meaningful.
#TODO: Revise `name`s.

resource "google_cloud_run_service" "run_default" {
  for_each = toset(var.cloudrun_regions)
  name     = "cloudrun-app-${each.value}"
  location = each.value

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
  for_each = toset(var.cloudrun_regions)
  location = google_cloud_run_service.run_default[each.value].location
  service  = google_cloud_run_service.run_default[each.value].name
  role     = "roles/run.invoker"
  member   = "allUsers"
}

#TODO: Mix a CDN backend bucket in.
