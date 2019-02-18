# SECURITY GROUP FOR PUBLIC ENDPOINTS
resource "aws_security_group" "public" {
  name        = "${terraform.workspace}_public"
  description = "${upper(terraform.workspace)} Public Endpoint Security Rules"
  vpc_id      = "${aws_vpc.main.id}"

  # Inbound HTTPS(443) Access
  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["${var.acl_inbound_https_access}"]
  }

  # Inbound SSH(22) Access
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["${aws_vpc.main.cidr_block}", "${var.acl_inbound_ssh_access}"]
  }
  
  # Inbound All Access
  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = -1
    cidr_blocks = ["${aws_vpc.main.cidr_block}", "${var.acl_inbound_all_access}"]
  }

  # Outbound All Access
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = -1
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags {
    Name        = "${terraform.workspace}_public"
    Environment = "${lower(terraform.workspace)}"
    Stack       = "environment"
  }
}
