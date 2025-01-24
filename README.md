# DevOps-Engineer-Assessment-Task

# Deploying a Web Application on AWS EKS with Terraform, Docker, and Prometheus Monitoring

This repository provides a comprehensive guide to deploying a containerized web application on **AWS EKS** using **Terraform** for provisioning, **Docker** for containerization, and **Kubernetes** for orchestration. Additionally, **Prometheus** used for monitoring the application and Kubernetes cluster.

## Prerequisites

Before you begin, ensure that you have the following tools installed on your local machine:

- **AWS CLI**: [Installation Guide](https://docs.aws.amazon.com/cli/latest/userguide/install-cliv2.html)
- **Terraform**: [Installation Guide](https://www.terraform.io/downloads.html)
- **kubectl**: [Installation Guide](https://kubernetes.io/docs/tasks/tools/install-kubectl/)
- **Docker**: [Installation Guide](https://docs.docker.com/get-docker/)
- **Helm** (for Prometheus/Grafana installation): [Installation Guide](https://helm.sh/docs/intro/install/)

## Step 1: Set Up AWS Credentials

Ensure your AWS credentials are correctly configured for Terraform and `kubectl` to interact with AWS services:

1. Run the following command to configure your AWS credentials:

   ```bash
   aws configure


Stage-1 (We will install Terraform in Our local machine )
