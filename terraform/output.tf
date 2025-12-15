output "vm_names" {
  description = "Names of the devops VMs"
  value       = [for vm in google_compute_instance.devops_vm : vm.name]
}

output "vm_public_ips" {
  description = "Public IPs of the devops VMs"
  value       = [for vm in google_compute_instance.devops_vm : vm.network_interface[0].access_config[0].nat_ip]
}

output "vpc_name" {
  description = "Name of the VPC"
  value       = google_compute_network.devops_vpc.name
}

output "subnet_name" {
  description = "Name of the subnet"
  value       = google_compute_subnetwork.devops_subnet.name
}
