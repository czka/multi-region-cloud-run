### What
This is a basic multi-region Cloud Run setup in Terraform. Based on:
- https://cloud.google.com/run/docs/multiple-regions#terraform, which pointed at:
  - https://github.com/terraform-google-modules/terraform-docs-samples/blob/main/cloud_run_service_multiple_regions/

### How

#### 1. Terraform setup:
   - Comment the `backend "gcs" {}` block in `providers.tf` to temporarily use the default `"local"` Terraform backend.
     You will uncomment it back later.
   - Initialize the Terraform state using the local backend: `terraform init`.
   - Create a `terraform.tfvars` file (included in [`.gitignore`](.gitignore), to avoid committing config details to a
     public repo) containing values for the following variables:
     - `var.gcp_project`
     - `var.terraform_bucket_location`
     - Optional: `var.terraform_bucket_name`. If not set, a random "pet" name with a `terraform-` prefix will be used
       (generated with [`random_pet`](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/pet)).
   - Create the GCS bucket for the remote Terraform backend:
     `terraform apply -target google_storage_bucket.terraform_backend`.
   - Enable the remote Terraform backend:
     - Uncomment back the `backend "gcs" {}` block in `providers.tf`.
     - Add a `gcs.tfbackend` file (included in [`.gitignore`](.gitignore), to avoid committing config details to a public
       repo), which defines (at least) the `bucket` name, using the name of the Terraform bucket you've created (as per
       `terraform output terraform_bucket_name`):
       ```
       bucket = "<your Terraform bucket name>"
       ```
       Reference:
       - https://developer.hashicorp.com/terraform/language/settings/backends/configuration#file
       - https://developer.hashicorp.com/terraform/language/settings/backends/gcs#configuration-variables
   - Initialize the remote Terraform backend, migrating the local state there: `terraform init -backend-config=gcs.tfbackend -migrate-state`

#### 2. Cloud Run setup:
- In `terraform.tfvars` specify values for:
  - `var.cloudrun_regions`
  - `var.cloudrun_domain_name`
  - `var.cloudrun_image`
- Create all the things: `terraform apply`.
- TODO: observe how a region-specific CR instance serves the traffic.
