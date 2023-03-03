resource "aws_iam_role" "cluster_role" {
  name = "eks-cluster_role"

  assume_role_policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "eks.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
POLICY
}

resource "aws_iam_role_policy_attachment" "AmazonEKSClusterPolicy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
  role       = aws_iam_role.cluster_role.name
}

resource "aws_eks_cluster" "cluster" {
  name     = "cluster"
  role_arn = aws_iam_role.cluster_role.arn

  vpc_config {
    subnet_ids = [
      module.subnet_2.subnet_2_id,
      module.subnet.subnet_id
    ]
    security_group_ids = [module.security_group_public.security_group_id]
    endpoint_private_access = true
  }

  depends_on = [aws_iam_role_policy_attachment.AmazonEKSClusterPolicy]
}