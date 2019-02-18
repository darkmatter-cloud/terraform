# Module: aws/vpc-environment

Version 1.0.0

This terraform module provisions an environment in an AWS Virtual Private Cloud with the following base components:

## Components

* Virtual Private Cloud
    * Subnets 
        * Public Subnets across mapped Availability Zones
        * Private Subnets across mapped Availability Zones
    * Route Tables
        * Public Route Table (associated to all Public Subnets)
        * Private Route Table (associated to all Private Subnets)
    * Internet Gateway (igw)
        * For Public Subnet Inbound/Outbound Access to Internet
    * NAT Gateway (ngw)
        * For Private Subnet Outbound Access to Internet
    * Network Access Control List
        * Inbound Rules
        * Outbound Rules
    * Firewall Security Groups
        * Public Inbound Rules
        * Private Inbound Rules
        * Outbound Rules
* Route53 DNS
    * Public Hosted Zone
    * Private Hosted Zone
* S3 Storage
    * S3 Bucket
        * Versioned
        * Encrypted
        * Default Retention Policies for log/ and tmp/ directory objects
    * S3 VPC Endpoint
        * For Private Network Access to S3
* Encryption
    * KMS Key for the Environment


## Example Module Usage

#### backend.tf
    terraform {
        backend "s3" {
            bucket = "your_s3_bucket"
            key    = "environment"
            region = "us-east-1"
        }
    }

#### main.tf
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