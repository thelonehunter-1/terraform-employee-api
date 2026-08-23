resource "aws_s3_bucket" "tf_state" {
  bucket = "soumyendra-terraform-state-620969610190"
}

resource "aws_dynamodb_table" "terraform_lock" {

  name         = "terraform-state-lock"
  billing_mode = "PAY_PER_REQUEST"

  hash_key = "LockID"

  attribute {
    name = "LockID"
    type = "S"
  }
}


