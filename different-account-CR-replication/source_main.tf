resource "aws_iam_role" "s3_role" {
  
  provider = aws.source
  name = "s3-cross-account-role"
  assume_role_policy = jsonencode({
    "Version": "2012-10-17",
    "Statement": [
      {
        "Action" : "sts:AssumeRole",
        "Effect" : "Allow",
        Sid    = "",
        Principal = {
          Service = "s3.amazonaws.com"
        }
      }
    ]   
}
)
  
}


resource "aws_iam_policy" "s3-replication-policy" {

  provider = aws.source
  name = "s3-replication-policy"
  policy = jsonencode({
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": [
        "s3:GetReplicationConfiguration",
        "s3:ListBucket"
      ],
      "Effect": "Allow",
      "Resource": [
        aws_s3_bucket.borah_bucket.arn
      ]
    },
    {
      "Action": [
        "s3:GetObjectVersion",
        "s3:GetObjectVersionForReplication",
        "s3:GetObjectVersionAcl"
      ],
      "Effect": "Allow",
      "Resource": [
        "${aws_s3_bucket.borah_bucket.arn}/*"
      ]
    },
    {
      "Action": [
        "s3:ReplicateObject",
        "s3:ReplicateDelete"
      ],
      "Effect": "Allow",
      "Resource": "${aws_s3_bucket.borah_replication_destination.arn}/*"
    }
  ]
  })
}

resource "aws_iam_role_policy_attachment" "policy-2-role" {
  provider = aws.source
  role = aws_iam_role.s3_role.name
  policy_arn = aws_iam_policy.s3-replication-policy.arn
  
}

resource "aws_s3_bucket" "borah_bucket" {
    bucket = "borah-bkt-account001"
    provider = aws.source
    
    acl = "private"

    versioning {
      enabled = true
    }

    replication_configuration {
    role = aws_iam_role.s3_role.arn
    
    rules {
      id = "foobar"
      prefix = ""
      status = "Enabled"

      destination {
        bucket = aws_s3_bucket.borah_replication_destination.arn
        storage_class = "STANDARD"
      }

    
      

    }
    
  }


}

resource "aws_s3_bucket_object" "bucket-content" {
  bucket = aws_s3_bucket.borah_bucket.id
  provider = aws.source
  key = "sample.txt"
  source = "${path.module}/sample.txt"
  
}