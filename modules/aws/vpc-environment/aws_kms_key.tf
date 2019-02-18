resource "aws_kms_key" "main" {
  description = "${terraform.workspace} kms key"
}

resource "aws_kms_alias" "main" {
  name          = "alias/${terraform.workspace}"
  target_key_id = "${aws_kms_key.main.key_id}"
}
