provider "azurerm" {
  features {}
}

provider "kubernetes" {
  host                   = module.k8s_cluster.kube_config.0.host
  client_certificate     = base64decode(module.k8s_cluster.kube_config.0.client_certificate)
  client_key             = base64decode(module.k8s_cluster.kube_config.0.client_key)
  cluster_ca_certificate = base64decode(module.k8s_cluster.kube_config.0.cluster_ca_certificate)
}

provider "helm" {
  kubernetes {
    host                   = module.k8s_cluster.kube_config.0.host
    client_certificate     = base64decode(module.k8s_cluster.kube_config.0.client_certificate)
    client_key             = base64decode(module.k8s_cluster.kube_config.0.client_key)
    cluster_ca_certificate = base64decode(module.k8s_cluster.kube_config.0.cluster_ca_certificate)
  }
}

provider "kubectl" {
  host                   = module.k8s_cluster.kube_config.0.host
  client_certificate     = base64decode(module.k8s_cluster.kube_config.0.client_certificate)
  client_key             = base64decode(module.k8s_cluster.kube_config.0.client_key)
  cluster_ca_certificate = base64decode(module.k8s_cluster.kube_config.0.cluster_ca_certificate)
  load_config_file       = false
}
