terraform {
  required_providers {
    yandex = {
      source = "yandex-cloud/yandex"
    }
  }
  required_version = ">= 0.13"

  backend "s3" {
    endpoints = {
      s3 = "https://storage.yandexcloud.net"
    }
    bucket     = "horseinthesky-state"
    region     = "ru-central1"
    key        = "terraform.tfstate"
    access_key = "YCAJE4_SRl00sBEGS0uwDpvRY"

    skip_region_validation      = true
    skip_credentials_validation = true
    skip_requesting_account_id  = true  # необходимая опция Terraform для версии 1.6.1 и старше.
    skip_s3_checksum            = true  # необходимая опция при описании бэкенда для Terraform версии 1.6.3 и старше.

  }
}

provider "yandex" {
  cloud_id  = var.cloud-id
  folder_id = var.folder-id
  zone      = "ru-central1-d"
}
