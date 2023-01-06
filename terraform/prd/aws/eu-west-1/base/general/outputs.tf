output "vpc" {
  value = {
    private_subnets = module.vpc.private_subnets
    id              = module.vpc.vpc_id
  }
}
