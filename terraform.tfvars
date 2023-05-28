# ----------------------root/terraform.tfvars-------------------
region = "us-east-1"

vpc_cidr = "172.16.0.0/16"

enable_dns_support = "true"

enable_dns_hostnames = "true"

enable_classiclink = "false"

enable_classiclink_dns_support = "false"

preferred_number_of_public_subnets = 2

preferred_number_of_private_subnets = 4

ami = "ami-0261755bbcb8c4a84"

keypair = "PBL"

account_no = "633880500398"

master-password = "devopspblproject"

master-username = "teague"


tags = {
  Enviroment      = "production"
  Owner-Email     = "hacksoftteam2012@gmail.com"
  Managed-By      = "Terraform"
  Billing-Account = "633880500398"
}