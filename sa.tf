resource "yandex_iam_service_account" "jim" {
  name        = "jim"
  description = "a nice guy"
}

resource "yandex_resourcemanager_cloud_iam_member" "editor" {
  role     = "editor"
  cloud_id = var.cloud-id
  member   = "serviceAccount:${yandex_iam_service_account.jim.id}"
}
