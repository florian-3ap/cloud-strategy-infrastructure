output "network_name" {
  value = google_compute_network.vpc.name
}

output "subnet_name" {
  value = google_compute_subnetwork.subnet.name
}

output "ip_address" {
  value = google_compute_address.static_ip.address
}
