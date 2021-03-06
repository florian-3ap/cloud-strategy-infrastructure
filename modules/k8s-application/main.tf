terraform {
  required_providers {
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = ">= 2.11.0"
    }
  }
  required_version = ">= 0.14"
}

locals {
  db_kubernetes_secret_name = "postgres-root-db-user"
}

resource "kubernetes_secret" "db_user_secret" {
  metadata {
    name = local.db_kubernetes_secret_name
  }

  data = {
    username = var.db_username
    password = var.db_password
  }
}

resource "kubernetes_deployment" "show-case-ui-deployment" {
  metadata {
    name = "show-case-ui"
  }

  spec {
    replicas = 2

    selector {
      match_labels = {
        app = "show-case-ui"
      }
    }

    template {
      metadata {
        labels = {
          app = "show-case-ui"
        }
      }

      spec {
        container {
          name  = "show-case-ui"
          image = "mandlon/show-case-ui:0.1.0-f2b700adb3e4ac0b3af7cc01b688c11774a94507"

          port {
            container_port = 3000
          }

          resources {
            requests = {
              cpu    = "25m"
              memory = "150Mi"
            }
          }

          readiness_probe {
            http_get {
              path   = "/"
              port   = 3000
              scheme = "HTTP"
            }
          }

          liveness_probe {
            http_get {
              path   = "/"
              port   = 3000
              scheme = "HTTP"
            }
          }

          env {
            name  = "REACT_APP_BASE_URL"
            value = "http://${var.show_case_ui_config.base_path}"
          }
        }
      }
    }
  }
}

resource "kubernetes_service" "show-case-ui-service" {
  metadata {
    name = "show-case-ui"
  }
  spec {
    selector = {
      app = "show-case-ui"
    }

    port {
      port        = 3000
      target_port = 3000
    }
  }

  depends_on = [kubernetes_deployment.show-case-ui-deployment]
}

resource "kubernetes_deployment" "person-management-service-deployment" {
  metadata {
    name = "person-management-service"
  }

  spec {
    replicas = 2

    selector {
      match_labels = {
        app = "person-management-service"
      }
    }

    template {
      metadata {
        labels = {
          app = "person-management-service"
        }
      }

      spec {
        container {
          name  = "person-management-service"
          image = "mandlon/person-management-service:0.0.1-SNAPSHOT-f2b700adb3e4ac0b3af7cc01b688c11774a94507"

          port {
            container_port = 8080
          }

          resources {
            requests = {
              cpu    = "25m"
              memory = "150Mi"
            }
          }

          readiness_probe {
            http_get {
              path   = "/person-management-service/actuator/health/readiness"
              port   = 8080
              scheme = "HTTP"
            }
            initial_delay_seconds = 30
            period_seconds        = 10
            timeout_seconds       = 5
          }

          liveness_probe {
            http_get {
              path   = "/person-management-service/actuator/health/liveness"
              port   = 8080
              scheme = "HTTP"
            }
            initial_delay_seconds = 100
            period_seconds        = 20
            timeout_seconds       = 5
          }

          env {
            name  = "DB_JDBC_URL"
            value = var.person_management_config.db_jdbc_url
          }
          env {
            name = "DB_USERNAME"
            value_from {
              secret_key_ref {
                name = local.db_kubernetes_secret_name
                key  = "username"
              }
            }
          }
          env {
            name = "DB_PASSWORD"
            value_from {
              secret_key_ref {
                name = local.db_kubernetes_secret_name
                key  = "password"
              }
            }
          }
        }
        dynamic container {
          for_each = var.cloud_sql_proxy_config.enabled ? [1] : []
          content {
            name  = "cloud-sql-proxy"
            image = "gcr.io/cloudsql-docker/gce-proxy:1.30.0"

            command = [
              "/cloud_sql_proxy", "-instances=$(CLOUDSQL_INSTANCE)=tcp:5432",
              "-log_debug_stdout=true"
            ]

            env {
              name  = "CLOUDSQL_INSTANCE"
              value = "cloud-strategy-poc:europe-west6:${var.cloud_sql_proxy_config.instance_name}"
            }

            security_context {
              run_as_non_root = true
            }
          }
        }
      }
    }
  }

  depends_on = [kubernetes_secret.db_user_secret]
}

resource "kubernetes_service" "person-management-service" {
  metadata {
    name = "person-management-service"
  }
  spec {
    selector = {
      app = "person-management-service"
    }

    port {
      port        = 8080
      target_port = 8080
    }
  }

  depends_on = [kubernetes_deployment.person-management-service-deployment]
}
