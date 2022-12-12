variable "gcp_project" {
  description = "The name of the target GCP project."
  type        = string
  default     = null
}

variable "terraform_bucket_name" {
  description = "Terraform backend bucket's name."
  type        = string
  default     = null
}

variable "terraform_bucket_location" {
  description = "Terraform backend bucket's location name."
  type        = string
  default     = null
}
