
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
This stack provisions the DEMO environment in AWS (Virtural Private Cloud ID vpc-012345678910abcde).

|Attribute | Value |
|:-----:|:-----------:|
|VPC CIDR Block|10.10.0.0/16|
|VPC Domain Name|example.com|
|VPC DHCP Name Servers|AmazonProvidedDNS|
|DNS Support Enabled|true|
|DNS Hostnames Enabled|true|

## Subnets
This stack provisions the following public and private subnets:

### Private Subnets
| Availability Zone | CIDR |
|:-----:|:-----------:|
| us-east-1a | 10.10.1.0/24 |
| us-east-1b | 10.10.2.0/24 |
| us-east-1c | 10.10.3.0/24 |

### Public Subnets
| Availability Zone | CIDR |
|:-----:|:-----------:|
| us-east-1a | 10.10.11.0/24 |
| us-east-1b | 10.10.12.0/24 |
| us-east-1c | 10.10.13.0/24 |

## Internet_Gateway (IGW)
Each environment will have an [Internet Gateway](http://docs.aws.amazon.com/AmazonVPC/latest/UserGuide/VPC_Internet_Gateway.html) provisioned to allow communication between the resources in the VPC and the internet. 

| Attribute | Value |
|:-----:|:-----------:|
|Internet Gateway ID|igw-012345678910abcde|

## NAT_Gateway (NGW)
Nearly all instances will be provisioned in a private subnet. [NAT Gateways](http://docs.aws.amazon.com/AmazonVPC/latest/UserGuide/vpc-nat-gateway.html) allow private instances in the VPC to communicate with the internet and other AWS resources. Each NAT Gateway has its own [Elastic IP address](http://docs.aws.amazon.com/AWSEC2/latest/UserGuide/elastic-ip-addresses-eip.html). The DEMO environment's Nat Gateway EIP is 33.233.33.233

| Attribute | Value |
|:-----:|:-----------:|
|NAT Gateway ID|nat-012345678910abcde|
|Elastic IP|33.233.33.233|

## Route53
This stack provisions the private and public DNS zones for `demo.example.com` and seeds forward and reverse DNS entries for subnets therein.

## Network_ACL
`acl-012345678910abcde`
The Network ACL serves as the external-most firewall for your VPC. Below are its most current rules.

### Inbound_Rules
Anything not explicitly allowed here will be denied

|ACTION|PORT|PROTOCOL|CIDR|NOTES|
|:-----:|:-----:|:-----:|:-----:|:-----:|
|ALLOW|ALL|ALL|10.10.0.0/16|This rule ensures all resources within this VPC can communicate with each other.|
|ALLOW|ALL|ALL|10.10.0.0/16 |This rule supports the traffic to and from the OPS network, and any other networks peered with your VPC.|
|ALLOW|22|TCP|10.10.0.0/16 |Allow SSH access from these networks.|
|ALLOW|443|TCP|0.0.0.0/0 |Allow HTTPS access from these networks.|
|ALLOW|1024-65535|TCP|0.0.0.0/0|All TCP [Ephemeral Ports](http://docs.aws.amazon.com/AmazonVPC/latest/UserGuide/VPC_ACLs.html#VPC_ACLs_Ephemeral_Ports) from anywhere.|
|ALLOW|1024-65535|UDP|0.0.0.0/0|All UDP [Ephemeral Ports](http://docs.aws.amazon.com/AmazonVPC/latest/UserGuide/VPC_ACLs.html#VPC_ACLs_Ephemeral_Ports) from anywhere.|
|ALLOW|123|UDP|0.0.0.0/0|Support the Network Time Protocol.|
|ALLOW|ALL|ICMP|0.0.0.0/0|All ICMP pings from anywhere.|

### Outbound_Rules
 - ALLOW all from anywhere

## Security_Groups
This stack provisions a private and public security group for resources in the DEMO network. Below are its most current rules.

### Private_Inbound_Rules
Anything not explicitly allowed here will be denied

|ACTION|PORT|PROTOCOL|CIDR|NOTES|
|:-----:|:-----:|:-----:|:-----:|:-----:|
|ALLOW|ALL|ALL|10.10.0.0/16|This rule ensures all resources within this VPC can communicate with each other.|
|ALLOW|ALL|ALL|10.10.0.0/16 |This rule supports the traffic to and from the OPS network, and any other networks peered with your VPC.|

### Public_Inbound_Rules
Anything not explicitly allowed here will be denied

|ACTION|PORT|PROTOCOL|CIDR|NOTES|
|:-----:|:-----:|:-----:|:-----:|:-----:|
|ALLOW|443|TCP|0.0.0.0/0|ALLOW all HTTPS from anywhere. If the environment doesn't serve HTTPS publicly, this is block on the Nat Gateway.|
|ALLOW|ALL|ALL|10.10.0.0/16 |This rule supports the traffic to and from the OPS network, and any other networks peered with your VPC.|

### Public_and_Private_Outbound_Rules
Anything not explicitly allowed here will be denied

|ACTION|PORT|PROTOCOL|CIDR|NOTES|
|:-----:|:-----:|:-----:|:-----:|:-----:|
|ALLOW|443|TCP|0.0.0.0/0|Allow all outbound connections, from anywhere|

## S3
S3 bucket names are globally shared across all of AWS' clients. The S3 resource provisioned for this environment may differ in format from other environments because of the global restriction. This environment's default S3 bucket is `example-demo`. By default, all resources are encrypted with the environment's KMS encryption key.

| Attribute | Value |
|:-----:|:-----------:|
|id|example-demo|
|arn|arn:aws:s3:::example-demo|
|bucket_domain_name|example-demo.s3.amazonaws.com|
|hosted_zone_id|ZYXWVUTSRQ1234|
|region|us-east-1|

## Encryption
All data will be encrypted by default. Unless otherwise specififed, data will be encrypted with the `demo` KMS key.

| Attribute | Value |
|:-----:|:-----------:|
|arn|arn:aws:kms:us-east-1:012345678910:key/abcdefgh-1234-5678-910i-jklmnopqrstu|
|key_id|abcdefgh-1234-5678-910i-jklmnopqrstu|
|alias|alias/demo|
