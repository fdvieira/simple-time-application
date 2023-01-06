module "s3_bucket" {
  source = "terraform-aws-modules/s3-bucket/aws"

  bucket = var.bucket_name
  acl    = var.bucket_acl
}

resource "aws_dynamodb_table" "terraform-lock" {
  name           = var.dynamodb_name
  read_capacity  = 5
  write_capacity = 5
  hash_key       = "LockID"
  attribute {
    name = "LockID"
    type = "S"
  }
  tags = {
    "Name" = "DynamoDB Terraform State Lock Table"
  }
}
