variable "project_id" {
  description = "GCP project ID"
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
  type    = string
  default = "devops-vpc"
}

variable "subnet_name" {
  type    = string
  default = "devops-subnet"
}

variable "subnet_cidr" {
  type    = string
  default = "10.10.0.0/16"
}

variable "vm_name" {
  type    = string
  default = "devops-vm"
}

variable "machine_type" {
  type    = string
  default = "e2-medium"
}

variable "ssh_user" {
  description = "Linux SSH username"
  type        = string
}

variable "ssh_public_key_path" {
  description = "Path to SSH public key"
  type        = string
}
