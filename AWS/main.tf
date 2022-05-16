module "network" {
  source = "./modules/network"

  project_id = var.project_id
  region     = var.region
}

module "security_group" {
  source = "./modules/aws_security_group"

  vpc_id = module.network.vpc_id
}

module "k8s_cluster" {
  source = "./modules/k8s-cluster"

  project_id = var.project_id
  vpc_id     = module.network.vpc_id
  subnets    = module.network.public_subnets

  depends_on = [module.network]
}

module "rds" {
  source = "./modules/rds"

  db_subnet_group_name   = module.network.rds_subnet_group_name
  vpc_security_group_ids = [module.security_group.rds_security_group_id]

  depends_on = [module.network, module.security_group]
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

  show_case_ui_config = {
    base_path = module.network.public_ips[0]
  }

  person_management_config = {
    db_jdbc_url = "jdbc:postgresql://${module.rds.rds_address}:${module.rds.port}/${module.rds.db_name}"
  }

  depends_on = [module.network, module.k8s_cluster, module.rds]
}

module "k8s_nginx_ingress" {
  source = "../modules/k8s-nginx-ingress"

  project_id = var.project_id

  cloud_provider = "aws"
  eip_ids        = module.network.aws_eip_ids
  subnet_ids     = module.network.public_subnets

  depends_on = [module.network, module.k8s_cluster]
}
