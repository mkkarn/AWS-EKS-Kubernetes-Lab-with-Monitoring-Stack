terraform {
  backend "s3" {
    bucket         = "your-unique-terraform-state-bucket-ap-south-1" # CHANGE THIS
    key            = "eks-lab/dev/terraform.tfstate"
    region         = "ap-south-1"
    encrypt        = true
    dynamodb_table = "terraform-state-lock" # CHANGE THIS
  }
}
