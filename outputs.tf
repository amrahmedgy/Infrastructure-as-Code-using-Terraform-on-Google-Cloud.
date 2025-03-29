output "vpc_network_id" {
  description = "ID of the VPC network"
  value       = google_compute_network.vpc_network.id
}

output "vm_instance_name" {
  description = "Name of the VM instance"
  value       = google_compute_instance.vm_instance.name
}

output "vm_instance_external_ip" {
  description = "External IP address of the VM instance"
  value       = google_compute_address.vm_static_ip.address
}

output "vm_instance_internal_ip" {
  description = "Internal IP address of the VM instance"
  value       = google_compute_instance.vm_instance.network_interface[0].network_ip
}

output "storage_bucket_url" {
  description = "URL of the storage bucket"
  value       = google_storage_bucket.app_bucket.url
}

output "dependent_vm_created" {
  description = "Whether the dependent VM was created"
  value       = var.create_dependent_vm
}

output "dependent_vm_name" {
  description = "Name of the dependent VM instance"
  value       = var.create_dependent_vm ? google_compute_instance.dependent_instance[0].name : "not created"
}
