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
  source  = "terraform-aws-modules/eks/aws"
  version = "17.24.0"

  cluster_name    = local.cluster_name
  cluster_version = local.cluster_version
  vpc_id          = module.vpc.vpc_id
  subnets         = module.vpc.private_subnets

  workers_group_defaults = {
    root_volume_type = "gp2"
  }

  worker_groups = [
    {
      name                          = "worker-group-1"
      instance_type                 = "t2.small"
      additional_userdata           = "echo foo bar"
      additional_security_group_ids = [module.security_group.worker_group_mgmt_id]
      asg_desired_capacity          = 2
    }
  ]

  depends_on = [
    module.vpc.vpc_id,
    module.vpc.private_subnets,
    module.security_group.worker_group_mgmt_id
  ]
}

data "aws_eks_cluster" "cluster" {
  name = module.eks.cluster_id
}

data "aws_eks_cluster_auth" "cluster" {
  name = module.eks.cluster_id
}
