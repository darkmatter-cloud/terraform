# Provision DHCP Options
resource "aws_vpc_dhcp_options" "main" {
  domain_name         = "${terraform.workspace}.${var.vpc_domain_name}"
  domain_name_servers = "${var.vpc_dhcp_domain_name_servers}"

  tags {
    Name        = "${terraform.workspace}"
    Environment = "${lower(terraform.workspace)}"
    Stack       = "environment"
  }
}

# Associate DHCP Options
resource "aws_vpc_dhcp_options_association" "main" {
  vpc_id          = "${aws_vpc.main.id}"
  dhcp_options_id = "${aws_vpc_dhcp_options.main.id}"
}