#-----------root/backend.tf----------------
# terraform {
#   backend "s3" {
#     bucket         = "pbl-teague-18"
#     key            = "global/s3/terraform.tfstate"
#     region         = "us-east-1"
#     dynamodb_table = "terraform-locks"
#     encrypt        = true
#   }
# }