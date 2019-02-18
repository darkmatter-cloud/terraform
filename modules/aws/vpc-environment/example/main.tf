# Deploy VPC Environment

# Configure the AWS Provider
provider aws {
  region = "us-east-1"
}

# Provision Environment Module
module "environment" {
  source = "../../../modules/aws/vpc-environment"

  # VPC
  vpc_cidr                     = "10.10.0.0/16"
  vpc_domain_name              = "example.com"
  vpc_dhcp_domain_name_servers = ["AmazonProvidedDNS"]

  # SUBNETS
  vpc_public_subnets = {
    us-east-1a = "10.10.11.0/24"
    us-east-1b = "10.10.12.0/24"
    us-east-1c = "10.10.13.0/24"
  }

  vpc_private_subnets = {
    us-east-1a = "10.10.1.0/24"
    us-east-1b = "10.10.2.0/24"
    us-east-1c = "10.10.3.0/24"
  }

  # NETWORK ACL
  acl_inbound_all_access   = ["10.10.0.0/16"]
  acl_inbound_ssh_access   = ["10.10.0.0/16"]
  acl_inbound_https_access = ["0.0.0.0/0"]

  # STORAGE
  s3_bucket_name           = "example-${terraform.workspace}"
  s3_endpoint_service_name = "com.amazonaws.us-east-1.s3"
}
