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

module "eks" {
  source = "./modules/eks"

  cluster_name         = local.cluster_name
  vpc_id               = module.vpc.vpc_id
  subnets              = module.vpc.private_subnets
  worker_group_mgmt_id = module.security_group.worker_group_mgmt_id
}

data "aws_eks_cluster" "cluster" {
  name = module.eks.cluster_id
}

data "aws_eks_cluster_auth" "cluster" {
  name = module.eks.cluster_id
}

module "rds" {
  source = "./modules/rds"

  db_subnet_group_name   = module.vpc.rds_subnet_group_name
  vpc_security_group_ids = [module.security_group.rds_security_group_id]
}
