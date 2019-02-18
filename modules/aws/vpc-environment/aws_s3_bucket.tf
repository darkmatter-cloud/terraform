# Primary S3 Bucket for VPC Enviroment (private)
resource "aws_s3_bucket" "main" {
  bucket = "${var.s3_bucket_name}"
  acl    = "private"

  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        kms_master_key_id = "${aws_kms_key.main.arn}"
        sse_algorithm     = "aws:kms"
      }
    }
  }

  # LOG RETENTION RULES
  lifecycle_rule {
    id      = "log"
    prefix = "log/"
    enabled = "${var.s3_log_retention_enabled}"

    tags = {
      "rule"      = "log"
      "autoclean" = "true"
    }

    transition {
      days          = "${var.s3_log_active_days}"
      storage_class = "STANDARD_IA" # or "ONEZONE_IA"
    }

    transition {
      days          = "${var.s3_log_archive_days}"
      storage_class = "GLACIER"
    }

    expiration {
      days = "${var.s3_log_expire_days}"
    }
  }

  # TMP RETENTION RULES
  lifecycle_rule {
    id      = "tmp"
    prefix  = "tmp/"
    enabled = "${var.s3_tmp_retention_enabled}"

    expiration {
      days = "${var.s3_tmp_expire_days}"
    }
  }



  versioning {
    enabled = "${var.s3_versioning_enabled}"
  }

  tags {
    Name        = "${terraform.workspace}-${var.s3_bucket_name}"
    Environment = "${terraform.workspace}"
    Stack       = "environment"
  }
}