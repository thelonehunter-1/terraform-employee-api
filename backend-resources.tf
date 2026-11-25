resource "aws_s3_bucket" "tf_state" {
  bucket = "default-terraform-state-803817393192"
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


