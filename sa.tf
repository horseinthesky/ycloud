resource "yandex_iam_service_account" "jim" {
  name        = "jim"
  description = "a nice guy"
}

resource "yandex_resourcemanager_folder_iam_member" "editor" {
  role      = "editor"
  folder_id = var.folder-id
  member    = "serviceAccount:${yandex_iam_service_account.jim.id}"
}
