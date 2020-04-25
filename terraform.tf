terraform {
  required_version = "~> 0.12"
  backend "gcs" {
    bucket = "BUCKET_NAME"
    prefix = "terraform/state"
    credentials = "./keys/gcs_key.json"
  }
}
