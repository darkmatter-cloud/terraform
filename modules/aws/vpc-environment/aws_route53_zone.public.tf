# CREATE PUBLIC HOSTED ZONE
resource "aws_route53_zone" "vpc_public" {
  name    = "${terraform.workspace}.${var.vpc_domain_name}."
  comment = "${terraform.workspace} Public Zone"
}

# PROVISION PUBLIC DNS ROUTES USING ROUTE53_SUBNET_SEEDER
# resource "null_resource" "basic_dns_public" {
#   count = "${length(values(var.vpc_public_subnets))}"

#   triggers {
#     subnet              = "${element(values(var.vpc_public_subnets),count.index)}"
#     forward_lookup_zone = "${aws_route53_zone.vpc_private.id}"
#   }

#   provisioner "local-exec" {
#     command = "${path.root}/../../../bin/route53_subnet_seeder -c ${element(values(var.vpc_public_subnets),count.index)} -f ${aws_route53_zone.vpc_private.id} -a UPSERT --verbose"
#   }
# }
