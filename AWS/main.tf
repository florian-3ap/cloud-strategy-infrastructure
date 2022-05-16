locals {
  cluster_name    = "${var.project_id}-eks"
  cluster_version = "1.22"
}

module "vpc" {
  source = "./modules/network"

  project_id   = var.project_id
  region       = var.region
  cluster_name = local.cluster_name
}

module "security_group" {
  source = "./modules/aws_security_group"

  vpc_id = module.vpc.vpc_id
}

module "k8s_cluster" {
  source = "./modules/k8s-cluster"

  cluster_name = local.cluster_name
  vpc_id       = module.vpc.vpc_id
  subnets      = module.vpc.public_subnets

  depends_on = [module.vpc]
}

module "rds" {
  source = "./modules/rds"

  db_subnet_group_name   = module.vpc.rds_subnet_group_name
  vpc_security_group_ids = [module.security_group.rds_security_group_id]

  depends_on = [module.vpc, module.security_group]
}

resource "kubernetes_secret" "db_root_user_secret" {
  metadata {
    name = "postgres-root-db-user"
  }

  data = {
    username = module.rds.username
    password = module.rds.password
  }

  depends_on = [module.rds]
}


module "k8s_application" {
  source = "../modules/k8s-application"

  show-case-ui-config = {
    base_path = module.vpc.public_ips[0]
  }

  person-management-config = {
    db_jdbc_url = "jdbc:postgresql://${module.rds.rds_address}:${module.rds.port}/${module.rds.db_name}"
  }

  depends_on = [module.vpc, module.k8s_cluster, module.rds]
}


module "k8s_nginx_ingress" {
  source = "../modules/k8s-nginx-ingress"

  project_id = var.project_id

  cloud_provider  = "aws"
  eip_allocations = module.vpc.aws_eip_ids
  subnets         = module.vpc.public_subnets

  depends_on = [module.vpc, module.k8s_cluster]
}
