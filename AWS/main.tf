locals {
  cluster_name    = "${var.project_id}-eks"
  cluster_version = "1.22"
}

module "vpc" {
  source = "./modules/vpc"

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
  subnets      = module.vpc.private_subnets

  depends_on = [module.vpc]
}

module "rds" {
  source = "./modules/rds"

  db_subnet_group_name   = module.vpc.rds_subnet_group_name
  vpc_security_group_ids = [module.security_group.rds_security_group_id]

  depends_on = [module.vpc, module.security_group, module.k8s_cluster]
}

module "k8s_application" {
  source = "../modules/k8s-application"

  show-case-ui-config = {
    base_path = module.vpc.ip_address
  }

  person-management-config = {
    db_jdbc_url = "jdbc:postgresql://${module.rds.rds_address}:${module.rds.port}/${module.rds.db_name}"
  }

  depends_on = [module.vpc.ip_address, module.k8s_cluster, module.rds]
}

#module "k8s-nginx-ingress" {
#  source = "../modules/k8s-nginx-ingress"
#
#  project_id = var.project_id
#  ip_address = module.vpc.ip_address
#
#  depends_on = [module.vpc.ip_address, module.eks, module.k8s-application]
#}
