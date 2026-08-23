terraform {

  backend "s3" {

    bucket         = "soumyendra-terraform-state-620969610190"
    key            = "employee-api/terraform.tfstate"
    region         = "ap-south-1"
    dynamodb_table = "terraform-state-lock"
    encrypt        = true

  }

}
