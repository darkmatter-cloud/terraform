# VPC INTERNET GATEWAY
resource "aws_internet_gateway" "main" {
  vpc_id     = "${aws_vpc.main.id}"
  depends_on = ["aws_vpc.main"]

  tags {
    Name        = "${terraform.workspace}_igw"
    Environment = "${lower(terraform.workspace)}"
    Stack       = "environment"
  }
}
