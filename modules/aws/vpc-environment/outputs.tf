###############################################################################
## VIRTUAL PRIVATE CLOUD
###############################################################################

output vpc_arn {
  value = "${aws_vpc.main.arn}"
}

output vpc_id {
  value = "${aws_vpc.main.id}"
}

output vpc_owner_id {
  value = "${aws_vpc.main.owner_id}"
}

output cidr_block {
  value = "${aws_vpc.main.cidr_block}"
}

output enable_dns_hostnames {
  value = "${aws_vpc.main.enable_dns_hostnames}"
}

output enable_dns_support {
  value = "${aws_vpc.main.enable_dns_support}"
}

###############################################################################
## GATEWAYS
###############################################################################

# INTERNET GATEWAY (igw)
output internet_gateway_id {
  value = "${aws_internet_gateway.main.id}"
}

# NAT GATEWAY (ngw)
output nat_gateway_id {
  value = "${aws_nat_gateway.main.id}"
}

output nat_gateway_subnet_id {
  value = "${aws_nat_gateway.main.subnet_id}"
}

output nat_gateway_private_ip {
  value = "${aws_nat_gateway.main.private_ip}"
}

output nat_gateway_public_ip {
  value = "${aws_nat_gateway.main.public_ip}"
}

###############################################################################
## SUBNETS
###############################################################################

# PRIVATE SUBNETS
output private_subnets {
  value = ["${aws_subnet.private.*.id}"]
}

# PUBLIC SUBNETS
output public_subnets {
  value = ["${aws_subnet.public.*.id}"]
}

###############################################################################
## ROUTE TABLES
###############################################################################

# PRIVATE ROUTE TABLE
output private_route_table {
  value = "${aws_route_table.private_subnets.id}"
}

# PUBLIC ROUTE TABLE
output public_route_table {
  value = "${aws_route_table.public_subnets.id}"
}

###############################################################################
## NETWORK ACCESS CONTROL LIST (ACL)
###############################################################################

# NETWORK ACL
output acl_id {
  value = "${aws_vpc.main.default_network_acl_id}"
}

###############################################################################
## SECURITY GROUPS (default)
###############################################################################

# PRIVATE SECURITY GROUP
output private_security_group {
  value = "${aws_security_group.private.id}"
}

# PUBLIC SECURITY GROUP
output public_security_group {
  value = "${aws_security_group.public.id}"
}

###############################################################################
## KMS ENCRYPTION KEY (default)
###############################################################################

# KMS KEY
output "kms_key" {
  value = "${aws_kms_key.main.arn}"
}


###############################################################################
## ROUTE53 DNS
###############################################################################

output private_dns_zone_id {
  value = "${aws_route53_zone.vpc_private.zone_id}"
}

output public_dns_zone_id {
  value = "${aws_route53_zone.vpc_public.zone_id}"
}

output vpc_domain_name {
  value = "${terraform.workspace}.${var.vpc_domain_name}"
}


###############################################################################
## SNS Topic
###############################################################################

output sns_topic_id {
  value = "${aws_sns_topic.main.id}"
}
output sns_topic_arn {
  value = "${aws_sns_topic.main.arn}"
}

###############################################################################
## S3 STORAGE
###############################################################################

output s3_bucket_id {
  value = "${aws_s3_bucket.main.id}"
}
output s3_bucket_arn {
  value = "${aws_s3_bucket.main.arn}"
}

output s3_bucket_region {
  value = "${aws_s3_bucket.main.region}"
}

###############################################################################
## MODULE VARIABLES
###############################################################################


output var_vpc_cidr {
  value = "${var.vpc_cidr}"
}

output var_vpc_private_subnets {
  value = "${var.vpc_private_subnets}"
}

output var_vpc_public_subnets {
  value = "${var.vpc_public_subnets}"
}

output var_acl_inbound_ssh_access {
  value = "${var.acl_inbound_ssh_access}"
}

output var_acl_inbound_https_access {
  value = "${var.acl_inbound_https_access}"
}

output var_acl_inbound_all_access {
  value = "${var.acl_inbound_all_access}"
}
