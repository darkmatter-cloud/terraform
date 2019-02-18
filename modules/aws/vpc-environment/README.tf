data "template_file" "readme" {
  template = <<EOF

# Environment
This stack provisions a base environment in an AWS Virtual Private Cloud with the following components:

## Stack Components

1. [Environment](#Environment)
    1. [Virtual Private Cloud (VPC)](#VPC)
        1. [Subnets](#Subnets)
        2. [Internet Gateway](#Internet_Gateway)
        3. [NAT Gateway](#NAT_Gateway)
        4. [Network ACL](#Network_ACL)
            1. [Inbound Rules](#Inbound_Rules)
            2. [Outbound Rules](#Outbound_Rules)
        5. [Security Groups](#Security_Groups)
            1. [Private Inbound Rules](#Private_Inbound_Rules)
            2. [Public Inbound Rules](#Public_Inbound_Rules)
            3. [Public and Private Outbound Rules](#Public_and_Private_Outbound_Rules)
    2. [Route53](#Route53)
    3. [S3 Storage](#S3)
    4. [Encryption](#Encryption)

## VPC
This stack provisions the ${upper(terraform.workspace)} environment in AWS (Virtural Private Cloud ID ${aws_vpc.main.id}).

|Attribute | Value |
|:-----:|:-----------:|
|VPC CIDR Block|${aws_vpc.main.cidr_block}|
|VPC Domain Name|${var.vpc_domain_name}|
|VPC DHCP Name Servers|${join("\n", aws_vpc_dhcp_options.main.domain_name_servers)}|
|DNS Support Enabled|${aws_vpc.main.enable_dns_support}|
|DNS Hostnames Enabled|${aws_vpc.main.enable_dns_hostnames}|

## Subnets
This stack provisions the following public and private subnets:

### Private Subnets
| Availability Zone | CIDR |
|:-----:|:-----------:|
${join("\n", formatlist("| %v | %v |", keys(var.vpc_private_subnets), values(var.vpc_private_subnets) ))}

### Public Subnets
| Availability Zone | CIDR |
|:-----:|:-----------:|
${join("\n", formatlist("| %v | %v |", keys(var.vpc_public_subnets), values(var.vpc_public_subnets) ))}

## Internet_Gateway (IGW)
Each environment will have an [Internet Gateway](http://docs.aws.amazon.com/AmazonVPC/latest/UserGuide/VPC_Internet_Gateway.html) provisioned to allow communication between the resources in the VPC and the internet. 

| Attribute | Value |
|:-----:|:-----------:|
|Internet Gateway ID|${aws_internet_gateway.main.id}|

## NAT_Gateway (NGW)
Nearly all instances will be provisioned in a private subnet. [NAT Gateways](http://docs.aws.amazon.com/AmazonVPC/latest/UserGuide/vpc-nat-gateway.html) allow private instances in the VPC to communicate with the internet and other AWS resources. Each NAT Gateway has its own [Elastic IP address](http://docs.aws.amazon.com/AWSEC2/latest/UserGuide/elastic-ip-addresses-eip.html). The ${upper(terraform.workspace)} environment's Nat Gateway EIP is ${aws_eip.ngw.public_ip}

| Attribute | Value |
|:-----:|:-----------:|
|NAT Gateway ID|${aws_nat_gateway.main.id}|
|Elastic IP|${aws_eip.ngw.public_ip}|

## Route53
This stack provisions the private and public DNS zones for `${terraform.workspace}.${var.vpc_domain_name}` and seeds forward and reverse DNS entries for subnets therein.

## Network_ACL
`${aws_vpc.main.default_network_acl_id}`
The Network ACL serves as the external-most firewall for your VPC. Below are its most current rules.

### Inbound_Rules
Anything not explicitly allowed here will be denied

|ACTION|PORT|PROTOCOL|CIDR|NOTES|
|:-----:|:-----:|:-----:|:-----:|:-----:|
|ALLOW|ALL|ALL|${aws_vpc.main.cidr_block}|This rule ensures all resources within this VPC can communicate with each other.|
|ALLOW|ALL|ALL|${join("\n", var.acl_inbound_all_access)} |This rule supports the traffic to and from the OPS network, and any other networks peered with your VPC.|
|ALLOW|22|TCP|${join("\n", var.acl_inbound_ssh_access)} |Allow SSH access from these networks.|
|ALLOW|443|TCP|${join("\n", var.acl_inbound_https_access)} |Allow HTTPS access from these networks.|
|${upper(aws_network_acl_rule.inbound_ephemeral_tcp.rule_action)}|1024-65535|TCP|0.0.0.0/0|All TCP [Ephemeral Ports](http://docs.aws.amazon.com/AmazonVPC/latest/UserGuide/VPC_ACLs.html#VPC_ACLs_Ephemeral_Ports) from anywhere.|
|${upper(aws_network_acl_rule.inbound_ephemeral_udp.rule_action)}|1024-65535|UDP|0.0.0.0/0|All UDP [Ephemeral Ports](http://docs.aws.amazon.com/AmazonVPC/latest/UserGuide/VPC_ACLs.html#VPC_ACLs_Ephemeral_Ports) from anywhere.|
|${upper(aws_network_acl_rule.inbound_ntp.rule_action)}|123|UDP|0.0.0.0/0|Support the Network Time Protocol.|
|${upper(aws_network_acl_rule.inbound_icmp.rule_action)}|ALL|ICMP|0.0.0.0/0|All ICMP pings from anywhere.|

### Outbound_Rules
 - ${upper(aws_network_acl_rule.outbound_internet.rule_action)} all from anywhere

## Security_Groups
This stack provisions a private and public security group for resources in the ${upper(terraform.workspace)} network. Below are its most current rules.

### Private_Inbound_Rules
Anything not explicitly allowed here will be denied

|ACTION|PORT|PROTOCOL|CIDR|NOTES|
|:-----:|:-----:|:-----:|:-----:|:-----:|
|ALLOW|ALL|ALL|${aws_vpc.main.cidr_block}|This rule ensures all resources within this VPC can communicate with each other.|
|ALLOW|ALL|ALL|${join("\n", var.acl_inbound_all_access)} |This rule supports the traffic to and from the OPS network, and any other networks peered with your VPC.|

### Public_Inbound_Rules
Anything not explicitly allowed here will be denied

|ACTION|PORT|PROTOCOL|CIDR|NOTES|
|:-----:|:-----:|:-----:|:-----:|:-----:|
|ALLOW|443|TCP|0.0.0.0/0|ALLOW all HTTPS from anywhere. If the environment doesn't serve HTTPS publicly, this is block on the Nat Gateway.|
|ALLOW|ALL|ALL|${join("\n", var.acl_inbound_all_access)} |This rule supports the traffic to and from the OPS network, and any other networks peered with your VPC.|

### Public_and_Private_Outbound_Rules
Anything not explicitly allowed here will be denied

|ACTION|PORT|PROTOCOL|CIDR|NOTES|
|:-----:|:-----:|:-----:|:-----:|:-----:|
|ALLOW|443|TCP|0.0.0.0/0|Allow all outbound connections, from anywhere|

## S3
S3 bucket names are globally shared across all of AWS' clients. The S3 resource provisioned for this environment may differ in format from other environments because of the global restriction. This environment's default S3 bucket is `${aws_s3_bucket.main.id}`. By default, all resources are encrypted with the environment's KMS encryption key.

| Attribute | Value |
|:-----:|:-----------:|
|id|${aws_s3_bucket.main.id}|
|arn|${aws_s3_bucket.main.arn}|
|bucket_domain_name|${aws_s3_bucket.main.bucket_domain_name}|
|hosted_zone_id|${aws_s3_bucket.main.hosted_zone_id}|
|region|${aws_s3_bucket.main.region}|

## Encryption
All data will be encrypted by default. Unless otherwise specififed, data will be encrypted with the `${terraform.env}` KMS key.

| Attribute | Value |
|:-----:|:-----------:|
|arn|${aws_kms_key.main.arn}|
|key_id|${aws_kms_key.main.key_id}|
|alias|${aws_kms_alias.main.name}|

EOF
}

resource "local_file" "readme" {
  content  = "${data.template_file.readme.rendered}"
  filename = "${path.root}/README.${upper(terraform.workspace)}.md"
}
