terraform {
  backend "s3" {
    bucket         = "EKS-manishk-bucket-ap-south-1" 
    key            = "eks-lab/dev/terraform.tfstate"
    region         = "ap-south-1"
    encrypt        = true
    dynamodb_table = "terraform-locks" 
  }
}
