# SECURITY GROUP FOR PRIVATE ENDPOINTS
resource "aws_security_group" "private" {
  name        = "${terraform.workspace}_private"
  description = "${upper(terraform.workspace)} Private Endpoint Security Rules"
  vpc_id      = "${aws_vpc.main.id}"

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
    Name        = "${terraform.workspace}_private"
    Environment = "${lower(terraform.workspace)}"
    Stack       = "environment"
  }
}
