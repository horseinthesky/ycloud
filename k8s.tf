locals {
  ssh_pairs = {
    horseinthesky = [
      file("~/.ssh/id_ed25519.pub"),
    ]
  }
}

variable "k8s-pod-ipv4-range" {
  default = "192.168.0.0/16"
}

variable "k8s-service-ipv4-range" {
  default = "10.255.255.0/24"
}

resource "yandex_kubernetes_cluster" "k8s" {
  name       = "default"
  network_id = data.yandex_vpc_network.default.id

  master {
    version   = "1.28"
    public_ip = true

    zonal {
      zone      = data.yandex_vpc_subnet.d.zone
      subnet_id = data.yandex_vpc_subnet.d.id
    }

    maintenance_policy {
      auto_upgrade = true

      maintenance_window {
        start_time = "01:00"
        duration   = "6h"
      }
    }
  }

  release_channel = "RAPID"

  service_account_id      = yandex_iam_service_account.jim.id
  node_service_account_id = yandex_iam_service_account.jim.id

  cluster_ipv4_range = var.k8s-pod-ipv4-range
  service_ipv4_range = var.k8s-service-ipv4-range
}

resource "yandex_kubernetes_node_group" "k8s-nodes" {
  cluster_id = yandex_kubernetes_cluster.k8s.id
  name       = "default"
  version    = "1.28"

  instance_template {
    platform_id = "standard-v3" # Ice Lake

    resources {
      cores  = 2
      memory = 4
    }

    boot_disk {
      type = "network-hdd"
      size = 64
    }

    network_interface {
      nat = true
      subnet_ids = [
        data.yandex_vpc_subnet.a.id,
        data.yandex_vpc_subnet.b.id,
        data.yandex_vpc_subnet.d.id,
      ]
    }

    metadata = {
      ssh-keys = join("\n", flatten([
        for username, ssh_keys in local.ssh_pairs : [
          for key in ssh_keys
          : "${username}:${key}"
        ]
      ]))
    }
  }

  scale_policy {
    fixed_scale {
      size = 3
    }
  }

  allocation_policy {
    location {
      zone = "ru-central1-a"
    }
    location {
      zone = "ru-central1-b"
    }
    location {
      zone = "ru-central1-d"
    }
  }

  maintenance_policy {
    auto_upgrade = true
    auto_repair  = true

    maintenance_window {
      start_time = "01:00"
      duration   = "6h"
    }
  }
}
