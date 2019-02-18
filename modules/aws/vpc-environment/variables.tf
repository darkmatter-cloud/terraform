# Virtual Private Cloud
variable vpc_domain_name {}

variable vpc_cidr {}

variable vpc_dhcp_domain_name {
  type    = "string"
  default = "example.com"
}

variable vpc_dhcp_domain_name_servers {
  type    = "list"
  default = ["AmazonProvidedDNS"]
}

# Subnet Maps
variable vpc_private_subnets {
  type = "map"
}

variable vpc_public_subnets {
  type = "map"
}

# Network ACL Config
variable acl_inbound_all_access {
  type    = "list"
  default = []
}

variable acl_inbound_ssh_access {
  type    = "list"
  default = []
}

variable acl_inbound_https_access {
  type    = "list"
  default = []
}

# S3 Storage

variable s3_bucket_name {
    type = "string"
}

variable s3_versioning_enabled {
    default = true
}

## log/ Directory Retention Settings
variable s3_log_retention_enabled {
    default = true
}

## Number of days to store objects (standard) in s3 bucket log/ directory
variable s3_log_active_days {
    default = 30
}

## Number of days to archive objects (glacier) in s3 bucket log/ directory
variable s3_log_archive_days {
    default = 60
}

## Number of days to expire objects in s3 bucket log/ directory
variable s3_log_expire_days {
    default = 90
}

## tmp/ Directory Retention Settings
variable s3_tmp_retention_enabled {
  default = true
}

## Number of days to expire objects in s3 bucket tmp/ directory
variable s3_tmp_expire_days {
  default = 30
}

## S3 Endpoint
variable "s3_endpoint_service_name" {
  type = "string"
  #default ="com.amazonaws.us-east-1.s3"
}
