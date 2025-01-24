provider "aws" {
  region = "us-west-2"
}

resource "aws_eks_cluster" "web_app_cluster" {
  name     = "web-app-cluster"
  role_arn = aws_iam_role.eks_cluster_role.arn

  vpc_config {
    subnet_ids = aws_subnet.web_subnet[*].id
  }
}

resource "aws_iam_role" "eks_cluster_role" {
  name = "eks-cluster-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action    = "sts:AssumeRole"
        Principal = {
          Service = "eks.amazonaws.com"
        }
        Effect    = "Allow"
        Sid       = ""
      }
    ]
  })
}

resource "aws_vpc" "web_vpc" {
  cidr_block = "10.0.0.0/16"
}

resource "aws_subnet" "web_subnet" {
  count             = 2
  vpc_id            = aws_vpc.web_vpc.id
  cidr_block        = cidrsubnet(aws_vpc.web_vpc.cidr_block, 8, count.index)
  availability_zone = element(data.aws_availability_zones.available.names, count.index)
}

output "cluster_endpoint" {
  value = aws_eks_cluster.web_app_cluster.endpoint
}

output "cluster_certificate" {
  value = aws_eks_cluster.web_app_cluster.certificate_authority[0].data
}

