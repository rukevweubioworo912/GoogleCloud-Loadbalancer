


resource "google_compute_network" "devops_vpc" {
  name                    = "devops-vpc"
  auto_create_subnetworks = false
}


resource "google_compute_subnetwork" "devops_subnet" {
  name          = "devops-subnet"
  ip_cidr_range = "10.0.1.0/24"
  region        = var.region
  network       = google_compute_network.devops_vpc.id
  #enable_flow_logs        = true
  private_ip_google_access = true
  
}


resource "google_compute_firewall" "allow_devops_ports" {
  name    = "allow-devops-ports"
  network = google_compute_network.devops_vpc.name
  target_tags = ["devops-server"]

  # SSH, restricted to public access (for now)
  allow {
    protocol = "tcp"
    ports    = ["22"]
  }

  # Allow HTTP/HTTPS access to the app
  allow {
    protocol = "tcp"
    ports    = ["80", "443"]
  }

  # Docker Swarm ports
  allow {
    protocol = "tcp"
    ports    = ["2377", "7946"]
  }
  allow {
    protocol = "udp"
    ports    = ["7946", "4789"]
  }

  # Open to all IPs (for public access)
  source_ranges = ["0.0.0.0/0"]
}


# checkov:skip=CKV_GCP_40,CKV_GCP_106 "Public IP and HTTP port intentionally open for internet access"
resource "google_compute_instance" "devops_vm" {
  count        = 2
  name         = "devops-vm-${count.index + 1}"
  machine_type = var.machine_type
  zone         = var.zone
  tags         = ["devops-server"]

  boot_disk {
    initialize_params {
      image = "ubuntu-os-cloud/ubuntu-2204-lts"
      size  = 30
    }
  }

  network_interface {
    subnetwork = google_compute_subnetwork.devops_subnet.id
    access_config {} # public IP
  }

  shielded_instance_config {
    enable_secure_boot          = true
    enable_vtpm                 = true
    enable_integrity_monitoring = true
  }

  metadata = {
    ssh-keys = "${var.ssh_user}:${file(var.ssh_public_key_path)}"
  }
}

