output "terraform_bucket_name" {
  description = "Terraform GCS backend's bucket name."
  value       = google_storage_bucket.terraform_backend.name
}
