variable "cloud_id" {
  description = "Yandex Cloud ID"
  type        = string
}

variable "folder_id" {
  description = "Yandex Cloud Folder ID"
  type        = string
}

variable "zone" {
  description = "Default availability zone"
  type        = string
  default     = "ru-central1-a"
}

variable "service_account_id" {
  description = "Service account ID for VMs"
  type        = string
}

variable "network_name" {
  description = "VPC network name"
  type        = string
  default     = "future20-network"
}

variable "public_subnet_cidr" {
  description = "CIDR for public subnet"
  type        = string
  default     = "10.0.1.0/24"
}

variable "private_subnet_cidr" {
  description = "CIDR for private subnet"
  type        = string
  default     = "10.0.2.0/24"
}

variable "vm_platform_id" {
  description = "Platform ID for compute instances"
  type        = string
  default     = "standard-v3"
}

variable "lakehouse_vm_cores" {
  description = "Number of CPU cores for Lakehouse VM"
  type        = number
  default     = 4
}

variable "lakehouse_vm_memory" {
  description = "RAM (GB) for Lakehouse VM"
  type        = number
  default     = 16
}

variable "lakehouse_disk_size" {
  description = "Disk size (GB) for Lakehouse VM"
  type        = number
  default     = 200
}

variable "orchestrator_vm_cores" {
  description = "Number of CPU cores for Orchestrator VM"
  type        = number
  default     = 2
}

variable "orchestrator_vm_memory" {
  description = "RAM (GB) for Orchestrator VM"
  type        = number
  default     = 8
}

variable "orchestrator_disk_size" {
  description = "Disk size (GB) for Orchestrator VM"
  type        = number
  default     = 100
}

variable "ssh_public_key" {
  description = "SSH public key for VM access"
  type        = string
}

variable "object_storage_bucket_name" {
  description = "Bucket name for Lakehouse data"
  type        = string
  default     = "future20-lakehouse"
}