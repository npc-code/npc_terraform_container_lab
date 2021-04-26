resource "aws_iam_role" "container_instance" {
  name               = "container_instance-${terraform.workspace}"
  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "ec2.amazonaws.com"
      },
      "Effect": "Allow"
    }
  ]
}
EOF

  tags = {
    tag-key = "tag-value"
  }

}
resource "aws_iam_instance_profile" "ec2_instance_role" {
  name = "iam_instance_profile-${terraform.workspace}"
  role = aws_iam_role.container_instance.name
}
resource "aws_iam_role_policy_attachment" "ec2_instance" {
  role       = aws_iam_role.container_instance.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonEC2ContainerServiceforEC2Role"
}