module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "19.4.3"

  cluster_name    = var.cluster_name
  cluster_version = var.cluster_version

  vpc_id                         = data.terraform_remote_state.base_general.outputs.vpc.id
  subnet_ids                     = data.terraform_remote_state.base_general.outputs.vpc.private_subnets
  cluster_endpoint_public_access = true

  eks_managed_node_group_defaults = {
    ami_type = "AL2_x86_64"

  }

  eks_managed_node_groups = var.eks_managed_node_groups

  tags = local.tags
}
