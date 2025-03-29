variable "project_id" {
  description = "Google Cloud Project ID"
  type        = string
}

variable "region" {
  description = "GCP region"
  type        = string
  default     = "us-central1"
}

variable "zone" {
  description = "GCP zone"
  type        = string
  default     = "us-central1-a"
}

variable "network_name" {
  description = "Name of the VPC network"
  type        = string
  default     = "terraform-network"
}

variable "subnet_name" {
  description = "Name of the subnet"
  type        = string
  default     = "terraform-subnet"
}

variable "subnet_cidr" {
  description = "CIDR range for the subnet"
  type        = string
  default     = "10.2.0.0/16"
}

variable "instance_name" {
  description = "Name of the VM instance"
  type        = string
  default     = "terraform-instance"
}

variable "machine_type" {
  description = "Machine type for the VM instance"
  type        = string
  default     = "e2-micro"
}

variable "disk_image" {
  description = "Disk image for the VM instance"
  type        = string
  default     = "debian-cloud/debian-11"
}

variable "disk_size" {
  description = "Boot disk size in GB"
  type        = number
  default     = 10
}

variable "disk_type" {
  description = "Boot disk type"
  type        = string
  default     = "pd-standard"
}

variable "static_ip_name" {
  description = "Name for the static IP address"
  type        = string
  default     = "terraform-static-ip"
}

variable "bucket_name" {
  description = "Name for the storage bucket"
  type        = string
  default     = "terraform-app-bucket"
}

variable "bucket_location" {
  description = "Location for the storage bucket"
  type        = string
  default     = "US"
}

variable "create_dependent_vm" {
  description = "Whether to create the dependent VM instance"
  type        = bool
  default     = false
}

variable "startup_script_path" {
  description = "Path to startup script file"
  type        = string
  default     = "scripts/startup.sh"
}
