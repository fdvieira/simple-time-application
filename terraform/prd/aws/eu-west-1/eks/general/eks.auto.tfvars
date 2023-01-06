cluster_name = "simple-time-eks"

cluster_version = "1.24"

eks_managed_node_groups = {
  general = {
    name = "general-node-1"

    instance_types = ["t3.small"]

    min_size     = 1
    max_size     = 2
    desired_size = 1
  }
}
