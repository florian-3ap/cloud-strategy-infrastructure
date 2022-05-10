output "public_ip" {
  value = azurerm_public_ip.nginx_ingress.ip_address
}
