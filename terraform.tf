resource "random_pet" "terraform_bucket" {
  count  = var.terraform_bucket_name == null ? 1 : 0
  prefix = "terraform"
  #TODO: any keepers?
}

resource "google_storage_bucket" "terraform_backend" {
  name     = var.terraform_bucket_name != null ? var.terraform_bucket_name : random_pet.terraform_bucket[0].id
  project  = var.gcp_project
  location = var.terraform_bucket_location

  uniform_bucket_level_access = true
  public_access_prevention    = "enforced"
  force_destroy               = false

  versioning {
    enabled = true
  }

  lifecycle {
    prevent_destroy = true
  }

  # TODO:
  #  encryption {
  #    default_kms_key_name = ""
  #  }
  #  logging {
  #    log_bucket = ""
  #  }
}
