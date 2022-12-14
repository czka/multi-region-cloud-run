#TODO: Change all "lb_default" resource names to something meaningful.
#TODO: Change "myservice*" `name`s as well.
#TODO: Revise `name`s.

resource "google_compute_global_address" "lb_default" {
#  provider = google-beta
  name     = "cloudrun-ip"

  # Use an explicit depends_on clause to wait until API is enabled
  depends_on = [
    google_project_service.compute_api
  ]
}

resource "google_compute_region_network_endpoint_group" "lb_default" {
#  provider              = google-beta
  for_each              = toset(var.cloudrun_regions)
  name                  = "cloudrun-neg"
  network_endpoint_type = "SERVERLESS"
  region                = each.value
  cloud_run {
    service = google_cloud_run_service.run_default[each.value].name
  }
}

resource "google_compute_backend_service" "lb_default" {
#  provider              = google-beta
  name                  = "cloudrun-backend"
  load_balancing_scheme = "EXTERNAL_MANAGED"

  dynamic "backend" {
    for_each = toset(var.cloudrun_regions)
    content {
      balancing_mode  = "UTILIZATION"
      capacity_scaler = 0.85
      group           = google_compute_region_network_endpoint_group.lb_default[backend.value].id
    }
  }

  # Use an explicit depends_on clause to wait until API is enabled
  depends_on = [
    google_project_service.compute_api,
  ]
}

resource "google_compute_url_map" "lb_default" {
#  provider        = google-beta
  name            = "myservice-lb-urlmap"
  default_service = google_compute_backend_service.lb_default.id

  path_matcher {
    name            = "allpaths"
    default_service = google_compute_backend_service.lb_default.id
    route_rules {
      priority = 1
      url_redirect {
        https_redirect         = true
        redirect_response_code = "MOVED_PERMANENTLY_DEFAULT"
      }
    }
  }
}

resource "google_compute_url_map" "https_default" {
#  provider = google-beta
  name     = "myservice-https-urlmap"

  default_url_redirect {
    redirect_response_code = "MOVED_PERMANENTLY_DEFAULT"
    https_redirect         = true
    strip_query            = false
  }
}

resource "google_compute_managed_ssl_certificate" "lb_default" {
#  provider = google-beta
  name     = "myservice-ssl-cert"

  managed {
    domains = [var.cloudrun_domain_name]
  }
}

resource "google_compute_target_https_proxy" "lb_default" {
#  provider = google-beta
  name     = "myservice-https-proxy"
  url_map  = google_compute_url_map.lb_default.id
  ssl_certificates = [
    google_compute_managed_ssl_certificate.lb_default.name
  ]
  depends_on = [
    google_compute_managed_ssl_certificate.lb_default
  ]
}

resource "google_compute_target_http_proxy" "https_default" {
#  provider = google-beta
  name     = "myservice-http-proxy"
  url_map  = google_compute_url_map.https_default.id

  depends_on = [
    google_compute_url_map.https_default
  ]
}

resource "google_compute_global_forwarding_rule" "lb_default" {
#  provider              = google-beta
  name                  = "myservice-lb-fr"
  load_balancing_scheme = "EXTERNAL_MANAGED"
  target                = google_compute_target_https_proxy.lb_default.id
  ip_address            = google_compute_global_address.lb_default.id
  port_range            = "443"
  depends_on            = [google_compute_target_https_proxy.lb_default]
}

resource "google_compute_global_forwarding_rule" "https_default" {
#  provider   = google-beta
  name       = "myservice-https-fr"
  target     = google_compute_target_http_proxy.https_default.id
  ip_address = google_compute_global_address.lb_default.id
  port_range = "80"
  depends_on = [google_compute_target_http_proxy.https_default]
}

#TODO:
#  gcloud compute addresses describe --global SERVICE_IP --format='value(address)'
#  (== terraform output load_balancer_ip_addr ?)
#  Update your domain's DNS records by adding an A record with this IP address.
