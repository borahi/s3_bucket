resource "aws_s3_bucket" "borah_bucket" {
    bucket = "borah_bucket_001"
    acl = "private"

    versioning {
      enabled = true
    }

}
  