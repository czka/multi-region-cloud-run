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

variable "cloudrun_domain_name" {
  type    = string
  default = null
}

variable "cloudrun_regions" {
  type    = list(string)
  default = [] #TODO TF list vs [] vs null?
}

variable "cloudrun_image" {
  type    = string
  default = "us-docker.pkg.dev/cloudrun/container/hello" #TODO: Add instructions to store these in your project's registry?
}
