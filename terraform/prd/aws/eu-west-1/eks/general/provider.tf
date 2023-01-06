provider "kubernetes" {
  host                   = module.eks.cluster_endpoint
  cluster_ca_certificate = base64decode(module.eks.cluster_certificate_authority_data)
}

provider "aws" {
  region     = var.region
   assume_role {
     role_arn = var.role_arn
   }
}

terraform {
  backend "s3" {
    bucket         = "tf-remotestate-prd"
    dynamodb_table = "tf-remotestate-prd"
    key            = "prd/aws/eu-west-1/eks/general/tfstate"
    region         = "eu-west-1"
    role_arn       = "arn:aws:iam::891126569531:role/sre-role"
  }
}

data "terraform_remote_state" "base_general" {
  backend = "s3"

  config = {
    bucket         = "tf-remotestate-prd"
    dynamodb_table = "tf-remotestate-prd"
    key            = format("%s/aws/%s/base/general/tfstate", var.environment, var.region)
    region         = "eu-west-1"
    role_arn       = var.role_arn
  }
}
