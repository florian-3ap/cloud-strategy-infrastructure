module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "< 18.0"

  cluster_name    = "${var.project_id}-eks"
  cluster_version = var.cluster_version
  vpc_id          = var.vpc_id
  subnets         = var.subnets

  write_kubeconfig = false

  workers_group_defaults = {
    root_volume_type = "gp2"
  }

  worker_groups = [
    {
      instance_type        = var.worker_group_instance_Type
      asg_desired_capacity = var.worker_group_count
    }
  ]
}
