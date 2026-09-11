terraform {
  required_providers {
    yandex = {
      source  = "yandex-cloud/yandex"
      version = "~> 0.119"
    }
  }

  required_version = ">= 1.8.0"
}

provider "yandex" {
  service_account_key_file = "key.json"

  cloud_id  = var.cloud_id
  folder_id = var.folder_id
  zone      = var.zone
}


# VPC network
resource "yandex_vpc_network" "this" {
  name = var.network_name
}

# Public subnet (for NAT / bastion / jumphost)
resource "yandex_vpc_subnet" "public" {
  name           = "${var.network_name}-public"
  zone           = var.zone
  network_id     = yandex_vpc_network.this.id
  v4_cidr_blocks = [var.public_subnet_cidr]
}

# Private subnet (for Lakehouse / Orchestrator)
resource "yandex_vpc_subnet" "private" {
  name           = "${var.network_name}-private"
  zone           = var.zone
  network_id     = yandex_vpc_network.this.id
  v4_cidr_blocks = [var.private_subnet_cidr]

  route_table_id = yandex_vpc_route_table.private.id
}


# NAT instance (simple variant)
resource "yandex_compute_instance" "nat" {
  name        = "nat-instance"
  platform_id = var.vm_platform_id
  zone        = var.zone

  resources {
    cores  = 2
    memory = 2
  }

  boot_disk {
    initialize_params {
      image_id = "fd800n45ob5uggkrooi8" # id базового Linux-образа (пример)
      size     = 10
    }
  }

  network_interface {
    subnet_id = yandex_vpc_subnet.public.id
    nat       = true
  }

  service_account_id = var.service_account_id

  metadata = {
    ssh-keys = "ubuntu:${var.ssh_public_key}"
  }
}

# Route table to send private traffic via NAT
resource "yandex_vpc_route_table" "private" {
  network_id = yandex_vpc_network.this.id
  name       = "${var.network_name}-private-rt"

  static_route {
    destination_prefix = "0.0.0.0/0"
    next_hop_address   = yandex_compute_instance.nat.network_interface.0.ip_address
  }
}



# Lakehouse VM
resource "yandex_compute_instance" "lakehouse" {
  name        = "lakehouse-vm"
  platform_id = var.vm_platform_id
  zone        = var.zone

  resources {
    cores  = var.lakehouse_vm_cores
    memory = var.lakehouse_vm_memory
  }

  boot_disk {
    initialize_params {
      image_id = "fd800n45ob5uggkrooi8" # базовый Linux
      size     = var.lakehouse_disk_size
      type     = "network-ssd"
    }
  }

  network_interface {
    subnet_id = yandex_vpc_subnet.private.id
    nat       = false
  }

  service_account_id = var.service_account_id

  metadata = {
    ssh-keys = "ubuntu:${var.ssh_public_key}"
    # cloud-init можно добавить для автоконфигурации Dremio / движка Lakehouse
  }
}

# Orchestrator VM (Airflow)
resource "yandex_compute_instance" "orchestrator" {
  name        = "orchestrator-vm"
  platform_id = var.vm_platform_id
  zone        = var.zone

  resources {
    cores  = var.orchestrator_vm_cores
    memory = var.orchestrator_vm_memory
  }

  boot_disk {
    initialize_params {
      image_id = "fd800n45ob5uggkrooi8"
      size     = var.orchestrator_disk_size
      type     = "network-ssd"
    }
  }

  network_interface {
    subnet_id = yandex_vpc_subnet.private.id
    nat       = false
  }

  service_account_id = var.service_account_id

  metadata = {
    ssh-keys = "ubuntu:${var.ssh_public_key}"
    # здесь можно через cloud-init ставить Docker + Airflow
  }
}

# Object Storage bucket for Lakehouse data
resource "yandex_storage_bucket" "lakehouse" {
  bucket = var.object_storage_bucket_name

  anonymous_access_flags {
    read = false
    list = false
  }
}