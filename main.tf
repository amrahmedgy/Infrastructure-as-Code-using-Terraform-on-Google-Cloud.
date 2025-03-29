terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~> 4.0"
    }
  }
  required_version = ">= 0.13.0"
}

provider "google" {
  project = var.project_id
  region  = var.region
  zone    = var.zone
}

# VPC Network
resource "google_compute_network" "vpc_network" {
  name                    = var.network_name
  auto_create_subnetworks = false
  description             = "Custom VPC Network created with Terraform"
}

# Subnet
resource "google_compute_subnetwork" "vpc_subnet" {
  name          = var.subnet_name
  ip_cidr_range = var.subnet_cidr
  region        = var.region
  network       = google_compute_network.vpc_network.id
}

# Firewall rule to allow SSH, HTTP, and HTTPS traffic
resource "google_compute_firewall" "allow_basic" {
  name    = "allow-basic"
  network = google_compute_network.vpc_network.name

  allow {
    protocol = "tcp"
    ports    = ["22", "80", "443"]
  }

  source_ranges = ["0.0.0.0/0"]
}

# Static IP address
resource "google_compute_address" "vm_static_ip" {
  name   = var.static_ip_name
  region = var.region
}

# VM instance
resource "google_compute_instance" "vm_instance" {
  name         = var.instance_name
  machine_type = var.machine_type
  tags         = ["web", "dev"]

  boot_disk {
    initialize_params {
      image = var.disk_image
      size  = var.disk_size
      type  = var.disk_type
    }
  }

  network_interface {
    network    = google_compute_network.vpc_network.name
    subnetwork = google_compute_subnetwork.vpc_subnet.name
    access_config {
      nat_ip = google_compute_address.vm_static_ip.address
    }
  }

  metadata_startup_script = file(var.startup_script_path)

  provisioner "local-exec" {
    command = "echo ${self.name}:${self.network_interface[0].access_config[0].nat_ip} >> ip_addresses.txt"
  }
}

# Storage bucket
resource "google_storage_bucket" "app_bucket" {
  name          = var.bucket_name
  location      = var.bucket_location
  force_destroy = true

  versioning {
    enabled = true
  }

  lifecycle_rule {
    condition {
      age = 30
    }
    action {
      type = "Delete"
    }
  }
}

# Second VM instance with dependency
resource "google_compute_instance" "dependent_instance" {
  count        = var.create_dependent_vm ? 1 : 0
  depends_on   = [google_storage_bucket.app_bucket]
  name         = "${var.instance_name}-dep"
  machine_type = var.machine_type

  boot_disk {
    initialize_params {
      image = var.disk_image
    }
  }

  network_interface {
    network    = google_compute_network.vpc_network.name
    subnetwork = google_compute_subnetwork.vpc_subnet.name
    access_config {
      // Ephemeral IP
    }
  }
}
