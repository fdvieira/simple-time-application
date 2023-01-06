data "aws_availability_zones" "available" {}

module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "3.18.1"

  name = var.vpc_name

  cidr = var.cidr_block
  azs  = data.aws_availability_zones.available.names

  private_subnets = var.private_subnets
  public_subnets  = var.public_subnets

  enable_nat_gateway   = true
  enable_dns_hostnames = true

  public_subnet_tags = var.subnets_tags.public_subnet_tags

  private_subnet_tags = var.subnets_tags.private_subnet_tags
}
