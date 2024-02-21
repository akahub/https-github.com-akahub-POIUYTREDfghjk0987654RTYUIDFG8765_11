// Defines the role the server will run as in AWS, with basic permissions.

resource "aws_iam_role" "server_role" {
 name = "${local.client}_${local.environment}_${local.project}_Role" // TODO

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "ec2.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF

}

resource "aws_iam_policy" "ec2_role_policy" { // TODO
  name        = "${local.client}_${local.environment}_${local.project}_Policy" // TODO
  description = "Base AWS Permissions"
  policy      = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": "ec2:DescribeTags",
            "Resource": "*"
        }
    ]
}
EOF

}

resource "aws_iam_role_policy_attachment" "ec2_policy_attach" {
  role       = aws_iam_role.server_role.name
  policy_arn = aws_iam_policy.ec2_role_policy.arn
}

// Instance profile
resource "aws_iam_instance_profile" "server_profile" {
  name = "${local.client}_${local.environment}_${local.project}_Profile" // TODO
  role = aws_iam_role.server_role.name
}

