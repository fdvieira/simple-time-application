vpc_name = "base-vpc"

cidr_block = "10.0.0.0/20"

private_subnets = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]

public_subnets = ["10.0.4.0/24", "10.0.5.0/24", "10.0.6.0/24"]

subnets_tags = {
  public_subnet_tags = {
    "kubernetes.io/cluster/simple-time-eks" = "shared"
    "kubernetes.io/role/elb"                = 1
  }
  private_subnet_tags = {
    "kubernetes.io/cluster/simple-time-eks" = "shared"
    "kubernetes.io/role/internal-elb"       = 1
  }
}
