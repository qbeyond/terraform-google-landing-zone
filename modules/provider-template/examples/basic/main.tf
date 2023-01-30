resource "random_id" "testprefix" {
  byte_length = 5
}

module "gcs-provider" {
  source          = "../.."
  bucket_name     = "test${random_id.testprefix.hex}"
  service_account = var.service_account
}