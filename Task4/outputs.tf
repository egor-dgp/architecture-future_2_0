output "network_id" {
  description = "ID созданной сети"
  value       = yandex_vpc_network.this.id
}

output "public_subnet_id" {
  value = yandex_vpc_subnet.public.id
}

output "private_subnet_id" {
  value = yandex_vpc_subnet.private.id
}

output "nat_instance_public_ip" {
  description = "Публичный IP NAT-инстанса (для bastion/dns)"
  value       = yandex_compute_instance.nat.network_interface[0].nat_ip_address
}

output "lakehouse_vm_private_ip" {
  description = "Приватный IP Lakehouse VM"
  value       = yandex_compute_instance.lakehouse.network_interface[0].ip_address
}

output "orchestrator_vm_private_ip" {
  description = "Приватный IP Orchestrator VM"
  value       = yandex_compute_instance.orchestrator.network_interface[0].ip_address
}

output "lakehouse_bucket" {
  description = "Имя S3-бакета для Lakehouse"
  value       = yandex_storage_bucket.lakehouse.bucket
}