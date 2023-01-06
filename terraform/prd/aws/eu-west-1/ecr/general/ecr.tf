module "ecr-repo" {
  source           = "../../../../../../terraform_modules/ecr/"
  ecr_name         = var.ecr_name
  image_mutability = var.image_mutability
}
