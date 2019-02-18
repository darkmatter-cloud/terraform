# PUBLIC SUBNETS FOR EACH AVAILABILITY ZONE
resource "aws_subnet" "public" {
  count                   = "${length(var.vpc_public_subnets)}"
  vpc_id                  = "${aws_vpc.main.id}"
  cidr_block              = "${element(values(var.vpc_public_subnets), count.index)}"
  availability_zone       = "${element(keys(var.vpc_public_subnets), count.index)}"
  map_public_ip_on_launch = true

  tags {
    Name        = "public_${terraform.workspace}_${element(keys(var.vpc_public_subnets), count.index)}"
    Environment = "${lower(terraform.workspace)}"
    Stack       = "environment"
  }
}

# PUBLIC SUBNETS ROUTE TABLE
resource "aws_route_table" "public_subnets" {
  vpc_id = "${aws_vpc.main.id}"

  tags {
    Name        = "${terraform.workspace}_public_rtb"
    Environment = "${lower(terraform.workspace)}"
    SStack       = "environment"
  }
}

# PUBLIC SUBNETS ROUTE TABLE ASSOCIATION
resource "aws_route_table_association" "public_subnets" {
  count          = "${length(var.vpc_public_subnets)}"
  subnet_id      = "${element(aws_subnet.public.*.id, count.index)}"
  route_table_id = "${aws_route_table.public_subnets.id}"
}

# DEFAULT ROUTE to INTERNET GATEWAY for PUBLIC SUBNETS
resource "aws_route" "public_subnet_igw" {
  route_table_id         = "${aws_route_table.public_subnets.id}"
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = "${aws_internet_gateway.main.id}"
}
