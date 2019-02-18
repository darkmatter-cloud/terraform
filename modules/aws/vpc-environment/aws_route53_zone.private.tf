# CREATE PRIVATE HOSTED ZONE
resource "aws_route53_zone" "vpc_private" {
  name    = "${terraform.workspace}.${var.vpc_domain_name}."
  comment = "${terraform.workspace} Private Zone"

  vpc {
    vpc_id = "${aws_vpc.main.id}"
  }
}

# PROVISION PRIVATE DNS ROUTES USING ROUTE53_SUBNET_SEEDER
# resource "null_resource" "basic_dns" {
#   count = "${length(values(var.vpc_private_subnets))}"


#   triggers {
#     subnet              = "${element(values(var.vpc_private_subnets),count.index)}"
#     forward_lookup_zone = "${aws_route53_zone.vpc_private.id}"
#   }


#   provisioner "local-exec" {
#     command = "${path.root}/../../../bin/route53_subnet_seeder -c ${element(values(var.vpc_private_subnets),count.index)} -f ${aws_route53_zone.vpc_private.id} -a UPSERT --verbose"
#   }
# }

