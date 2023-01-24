output "content" {
  value = templatefile("./providers.tf.tpl", {
    bucket_name     = var.bucket_name
    service_account = var.service_account
    }
  )
  description = "returns a provider config for a remote state in google storage buckets"
}
