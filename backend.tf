terraform {

  backend "s3" {

    bucket         = "default-terraform-state-803817393192"
    key            = "employee-api/terraform.tfstate"
    region         = "ap-southeast-2"
    dynamodb_table = "terraform-state-lock"
    encrypt        = true

  }

}
