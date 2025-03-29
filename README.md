# Infrastructure as Code with Terraform on GCP

![image](https://github.com/user-attachments/assets/c72742a7-7fe0-4241-b63a-c8f60d8443c7)


## Project Overview

This project demonstrates how to use HashiCorp Terraform to provision and manage infrastructure on Google Cloud Platform (GCP) following Infrastructure as Code (IaC) best practices. The code creates a basic networking and compute infrastructure including a custom VPC network, VM instances, static IP addresses, and storage buckets.

## Prerequisites

- [Google Cloud Platform Account](https://cloud.google.com)
- [Google Cloud SDK](https://cloud.google.com/sdk/docs/install)
- [Terraform](https://www.terraform.io/downloads.html) (v0.13.0 or newer)
- Basic understanding of GCP services
- A GCP project with billing enabled

## Features

- Custom VPC network creation
- VM instance provisioning with various configurations
- Static IP address allocation
- Cloud Storage bucket creation
- Resource dependencies management
- Basic provisioners for VM configuration

## Project Structure

```
terraform-gcp-infrastructure/
├── main.tf              # Main Terraform configuration
├── variables.tf         # Variable declarations
├── outputs.tf           # Output definitions
├── terraform.tfvars.example # Example variable values (rename to terraform.tfvars for use)
├── README.md            # Project documentation
├── LICENSE              # License file
└── .gitignore           # Git ignore file
```

## Quick Start

1. **Clone the repository**

```bash
git clone https://github.com/YOUR_USERNAME/terraform-gcp-infrastructure.git
cd terraform-gcp-infrastructure
```

2. **Configure your GCP credentials**

Either use application default credentials via gcloud CLI:

```bash
gcloud auth application-default login
```

Or create a service account key and set environment variable:

```bash
export GOOGLE_APPLICATION_CREDENTIALS="/path/to/service-account-key.json"
```

3. **Customize the configuration**

```bash
cp terraform.tfvars.example terraform.tfvars
# Edit terraform.tfvars with your project-specific values
```

4. **Initialize Terraform**

```bash
terraform init
```

5. **Plan your infrastructure changes**

```bash
terraform plan
```

6. **Apply the changes**

```bash
terraform apply
```

7. **Clean up when done**

```bash
terraform destroy
```

## Step-by-Step Guide

### Step 1: Setting up the VPC Network

This project starts by creating a custom Virtual Private Cloud (VPC) network that will host our resources. The network provides isolation and security for the infrastructure.

```hcl
resource "google_compute_network" "vpc_network" {
  name = var.network_name
  auto_create_subnetworks = false
  description = "Custom VPC Network for Terraform demo"
}

resource "google_compute_subnetwork" "vpc_subnet" {
  name          = var.subnet_name
  ip_cidr_range = var.subnet_cidr
  region        = var.region
  network       = google_compute_network.vpc_network.id
}
```

### Step 2: Creating a Compute Instance

Next, we create a VM instance in the VPC network:

```hcl
resource "google_compute_instance" "vm_instance" {
  name         = var.instance_name
  machine_type = var.machine_type
  zone         = var.zone
  
  boot_disk {
    initialize_params {
      image = var.disk_image
    }
  }

  network_interface {
    network = google_compute_network.vpc_network.name
    subnetwork = google_compute_subnetwork.vpc_subnet.name
    access_config {
      // Ephemeral IP
    }
  }
}
```

### Step 3: Assigning a Static IP

For services that need a consistent IP address:

```hcl
resource "google_compute_address" "static_ip" {
  name = var.static_ip_name
  region = var.region
}

# Update VM instance to use static IP
resource "google_compute_instance" "vm_instance" {
  # ... other configuration ...
  
  network_interface {
    # ... other configuration ...
    access_config {
      nat_ip = google_compute_address.static_ip.address
    }
  }
}
```

### Step 4: Setting Up Cloud Storage

Create a bucket for application data:

```hcl
resource "google_storage_bucket" "app_bucket" {
  name     = var.bucket_name
  location = var.bucket_location
  
  versioning {
    enabled = true
  }
}
```

### Step 5: Managing Resource Dependencies

Using explicit and implicit dependencies:

```hcl
resource "google_compute_instance" "dependent_instance" {
  depends_on = [google_storage_bucket.app_bucket]
  
  # ... VM configuration ...
}
```

## Advanced Usage

### Working with Provisioners

```hcl
resource "google_compute_instance" "vm_with_provisioner" {
  # ... VM configuration ...
  
  provisioner "local-exec" {
    command = "echo ${self.name}:${self.network_interface[0].access_config[0].nat_ip} >> ip_addresses.txt"
  }
}
```

### Using Terraform Variables

See `variables.tf` for all available variables to customize your deployment.

## Contributing

See [CONTRIBUTING.md](CONTRIBUTING.md) for details on how to contribute to this project.

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## Acknowledgments

- Based on Google Cloud Skills Boost lab: "Infrastructure as Code with Terraform"
- HashiCorp Terraform documentation
- Google Cloud Platform documentation
