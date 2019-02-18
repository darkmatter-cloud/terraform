# ELASTIC IP ADDRESS
resource "aws_eip" "ngw" {
  vpc        = true
  depends_on = ["aws_vpc.main"]
}

# NAT GATEWAT WITH ELASTIC IP
resource "aws_nat_gateway" "main" {
  allocation_id = "${aws_eip.ngw.id}"
  subnet_id     = "${aws_subnet.public.0.id}"
}
