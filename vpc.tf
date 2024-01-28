data "yandex_vpc_network" "default" {
  name = "default"
}

data "yandex_vpc_subnet" "a" {
  name = "default-ru-central1-a"
}

data "yandex_vpc_subnet" "b" {
  name = "default-ru-central1-b"
}

data "yandex_vpc_subnet" "d" {
  name = "default-ru-central1-d"
}
