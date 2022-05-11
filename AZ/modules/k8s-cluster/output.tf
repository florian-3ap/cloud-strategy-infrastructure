output "public_ip" {
  value = azurerm_public_ip.nginx_ingress.ip_address
}

output "kube_config" {
  value = azurerm_kubernetes_cluster.aks.kube_config
}
