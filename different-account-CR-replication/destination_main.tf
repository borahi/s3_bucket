resource "aws_s3_bucket" "borah_replication_destination" {
  provider = aws.destination
  bucket = "borah-replica-bkt-account002"
  acl = "private"

  versioning {
    enabled = true
  }

}

resource "aws_s3_bucket_policy" "destination" {
    provider = aws.destination
    bucket = aws_s3_bucket.borah_replication_destination.id

    policy = <<POLICY
  {
   "Version": "2008-10-17",
    "Id": "",
    "Statement": [
      {
        "Sid": "AllowReplication",
        "Effect": "Allow",
        "Principal": {
          "AWS": "arn:aws:iam::${var.source_account_id}:root"
        },
        "Action": [
          "s3:GetBucketVersioning",
          "s3:PutBucketVersioning",
          "s3:ReplicateObject",
          "s3:ReplicateDelete",
          "s3:ObjectOwnerOverrideToBucketOwner"
        ],
        "Resource": [
          "${aws_s3_bucket.borah_replication_destination.arn}",
          "${aws_s3_bucket.borah_replication_destination.arn}/*"
        ]
    },
    {
        "Sid": "AllowRead",
        "Effect": "Allow",
        "Principal": {
          "AWS": "*"
        },
        "Action": [
          "s3:List*",
          "s3:Get*"
        ],
        "Resource": [
          "${aws_s3_bucket.borah_replication_destination.arn}",
          "${aws_s3_bucket.borah_replication_destination.arn}/*"
        ]
      }
    ]


  }
  POLICY

}