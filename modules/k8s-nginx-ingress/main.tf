terraform {
  required_providers {
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = ">= 2.11.0"
    }
    kubectl = {
      source  = "gavinbunney/kubectl"
      version = ">= 1.14.0"
    }
  }
  required_version = ">= 0.14"
}

locals {
  values = var.cloud_provider == "aws" ? [
    <<-EOF
    controller:
      service:
        annotations:
          service.beta.kubernetes.io/aws-load-balancer-backend-protocol: tcp
          service.beta.kubernetes.io/aws-load-balancer-cross-zone-load-balancing-enabled: 'true'
          service.beta.kubernetes.io/aws-load-balancer-type: nlb
          service.beta.kubernetes.io/aws-load-balancer-subnets: ${join(", ", var.subnet_ids)}
          service.beta.kubernetes.io/aws-load-balancer-eip-allocations: ${join(",", var.eip_ids)}
        externalTrafficPolicy: Local
    EOF
  ] : [
    <<-EOF
    controller:
      service:
        loadBalancerIP: ${var.ip_address}
        externalTrafficPolicy: Local
    EOF
  ]
}

resource "kubectl_manifest" "ingress_configmap" {
  yaml_body = <<YAML
apiVersion: v1
kind: ConfigMap
metadata:
  labels:
    app.kubernetes.io/component: controller
    app.kubernetes.io/instance: ${var.project_id}
    app.kubernetes.io/name: ingress-nginx
  name: ${var.project_id}-ingress-nginx-controller
  namespace: default
data:
  enable-ocsp: "true"
  hsts: "true"
  hsts-include-subdomains: "true"
  hsts-max-age: "31536000"
  log-format-escape-json: "true"
  log-format-upstream: '{"message": "$request $status", "status": "$status", "requestTime": "$request_time", "requestLength": "$request_length", "responseLength": "$upstream_response_length", "nodeIp" : "$upstream_addr", "referer": "$http_referer", "userAgent": "$http_user_agent", "remoteIp": "$remote_addr", "service": "$proxy_upstream_name"}'
  server-tokens: "false"
YAML
}

resource "helm_release" "ingress_nginx_chart" {
  name       = "ingress-nginx"
  repository = "https://kubernetes.github.io/ingress-nginx/"
  chart      = "ingress-nginx"
  version    = "4.1.0"
  values     = local.values

  depends_on = [kubectl_manifest.ingress_configmap]
}

resource "kubernetes_ingress_v1" "ingress" {
  metadata {
    name        = "${var.project_id}-nginx-ingress"
    annotations = {
      "kubernetes.io/ingress.class"                       = "nginx"
      "nginx.ingress.kubernetes.io/force-ssl-redirect"    = "false"
      "nginx.ingress.kubernetes.io/proxy-body-size"       = "20m"
      "nginx.ingress.kubernetes.io/proxy-connect-timeout" = "180"
      "nginx.ingress.kubernetes.io/proxy-read-timeout"    = "180"
      "nginx.ingress.kubernetes.io/proxy-send-timeout"    = "180"
      "nginx.ingress.kubernetes.io/enable-cors"           = "true"
      "nginx.ingress.kubernetes.io/use-regex"             = "true"
    }
  }
  spec {
    rule {
      http {
        dynamic path {
          for_each = var.services
          iterator = service
          content {
            path = service.value.path
            backend {
              service {
                name = service.value.name
                port {
                  number = service.value.port
                }
              }
            }
          }
        }
      }
    }
  }

  depends_on = [helm_release.ingress_nginx_chart]
}
