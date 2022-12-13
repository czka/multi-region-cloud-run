output "terraform_bucket_name" {
  description = "Terraform GCS backend's bucket name."
  value       = google_storage_bucket.terraform_backend.name
}

output "load_balancer_ip_addr" {
  value = google_compute_global_address.lb_default.address
}
