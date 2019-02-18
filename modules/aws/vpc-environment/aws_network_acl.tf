## NETWORK ACL (Access Control List)
## Each VPC created in AWS comes with a Default Network ACL that can be managed, 
## but not destroyed. 
## Learn More https://www.terraform.io/docs/providers/aws/r/default_network_acl.html

## VPC Default Network ACL
resource "aws_default_network_acl" "main" {
  default_network_acl_id = "${aws_vpc.main.default_network_acl_id}"

  tags {
    Name        = "${lower(terraform.workspace)}_network_acl"
    Environment = "${lower(terraform.workspace)}"
    Stack       = "environment"
  }

  lifecycle {
    ignore_changes = ["subnet_ids", "egress", "ingress"]
  }

  depends_on     = ["aws_vpc.main"]
}

# Outbound Rule (Allow All Outbound Internet Traffic)
resource "aws_network_acl_rule" "outbound_internet" {
  network_acl_id = "${aws_default_network_acl.main.id}"
  rule_number    = 10
  egress         = true
  protocol       = -1
  rule_action    = "allow"
  cidr_block     = "0.0.0.0/0"
  depends_on     = ["aws_default_network_acl.main"]
}

# Inbound Rule (Allow All Local Network Traffic)
resource "aws_network_acl_rule" "inbound_local" {
  network_acl_id = "${aws_default_network_acl.main.id}"
  rule_number    = 10
  egress         = false
  protocol       = -1
  rule_action    = "allow"
  cidr_block     = "${var.vpc_cidr}"
  depends_on     = ["aws_default_network_acl.main"]
}

# Inbound Rule (Allow All ICMP Traffic)
resource "aws_network_acl_rule" "inbound_icmp" {
  network_acl_id = "${aws_default_network_acl.main.id}"
  rule_number    = 11
  egress         = false
  protocol       = "icmp"
  rule_action    = "allow"
  cidr_block     = "0.0.0.0/0"
  icmp_type      = -1
  icmp_code      = -1
  depends_on     = ["aws_default_network_acl.main"]
}

# Ephemeral Ports
# Allows inbound return traffic from hosts on the Internet that are responding
# to requests originating in the subnet. TCP/UDP Port Range 1024-65535

# Inbound Rule (Allow Ephemeral TCP Port Traffic)
resource "aws_network_acl_rule" "inbound_ephemeral_tcp" {
  network_acl_id = "${aws_default_network_acl.main.id}"
  rule_number    = 12
  egress         = false
  protocol       = "tcp"
  rule_action    = "allow"
  cidr_block     = "0.0.0.0/0"
  from_port      = 1024
  to_port        = 65535
  depends_on     = ["aws_default_network_acl.main"]
}

# Inbound Rule (Allow All Ephemeral UDP Port Traffic)
resource "aws_network_acl_rule" "inbound_ephemeral_udp" {
  network_acl_id = "${aws_default_network_acl.main.id}"
  rule_number    = 13
  egress         = false
  protocol       = "udp"
  rule_action    = "allow"
  cidr_block     = "0.0.0.0/0"
  from_port      = 1024
  to_port        = 65535
  depends_on     = ["aws_default_network_acl.main"]
}

# Inbound Rule (Allow NTP Time Synchronization)
resource "aws_network_acl_rule" "inbound_ntp" {
  network_acl_id = "${aws_default_network_acl.main.id}"
  rule_number    = 14
  egress         = false
  protocol       = "udp"
  rule_action    = "allow"
  cidr_block     = "0.0.0.0/0"
  from_port      = 123
  to_port        = 123
  depends_on     = ["aws_default_network_acl.main"]
}


# Inbound Rule (Allow All Access for Whitelisted IPs)
resource "aws_network_acl_rule" "inbound_all_access" {
  count          = "${length(var.acl_inbound_all_access)}"
  network_acl_id = "${aws_default_network_acl.main.id}"
  rule_number    = "${100 + count.index}"
  egress         = false
  protocol       = -1
  rule_action    = "allow"
  cidr_block     = "${element(var.acl_inbound_all_access, count.index)}"
  depends_on     = ["aws_default_network_acl.main"]
}

# Inbound Rule (Allow SSH Access for Whitelisted IPs)
resource "aws_network_acl_rule" "inbound_ssh_access" {
  count          = "${length(var.acl_inbound_ssh_access)}"
  network_acl_id = "${aws_default_network_acl.main.id}"
  rule_number    = "${200 + count.index}"
  egress         = false
  protocol       = "tcp"
  rule_action    = "allow"
  cidr_block     = "${element(var.acl_inbound_ssh_access, count.index)}"
  from_port      = 22
  to_port        = 22
  depends_on     = ["aws_default_network_acl.main"]
}

# Inbound Rule (Allow HTTPS Access for Whitelisted IPs)
resource "aws_network_acl_rule" "inbound_https_access" {
  count          = "${length(var.acl_inbound_https_access)}"
  network_acl_id = "${aws_default_network_acl.main.id}"
  rule_number    = "${300 + count.index}"
  egress         = false
  protocol       = "tcp"
  rule_action    = "allow"
  cidr_block     = "${element(var.acl_inbound_https_access, count.index)}"
  from_port      = 443
  to_port        = 443
  depends_on     = ["aws_default_network_acl.main"]
}
