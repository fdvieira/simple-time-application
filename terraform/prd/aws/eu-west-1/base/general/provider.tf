provider "aws" {
  region = var.region
  assume_role {
    role_arn = "arn:aws:iam::891126569531:role/sre-role"
  }
}

terraform {
  backend "s3" {
    bucket         = "tf-remotestate-prd"
    dynamodb_table = "tf-remotestate-prd"
    key            = "prd/aws/eu-west-1/base/general/tfstate"
    region         = "eu-west-1"
    role_arn       = "arn:aws:iam::891126569531:role/sre-role"
  }
}
