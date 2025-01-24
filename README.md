# DevOps-Engineer-Assessment-Task

***Clone the Repo and Check for Existing Setup***
First, clone my repository to your local machine if you haven't already:

git clone https://github.com/Swapnajit18/DevOps-Engineer-Assessment-Task.git
cd DevOps-Engineer-Assessment-Task

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


Step 2: Provision AWS Infrastructure with Terraform
2.1 Initialize Terraform
First, make sure you’ve pulled the repository to your local machine and navigated to the folder containing your Terraform files. Once you're there, you’ll need to initialize Terraform. You can do this by running terraform init. This command sets things up by downloading the necessary provider plugins and preparing your environment to work with AWS.

2.2 Plan Terraform Changes
Next, you should check what changes Terraform plans to make to your infrastructure before actually applying them. Use terraform plan for this. It will show you a detailed preview of the changes that will be made (like creating an EKS cluster or any related AWS resources). Take a moment to review this output to make sure everything looks good.

2.3 Apply Terraform Configuration
Finally, when you’re happy with the planned changes, you can apply the configuration by running terraform apply. Terraform will ask for confirmation by typing yes before it starts creating resources like your EKS cluster, VPC, IAM roles, and subnets. Once confirmed, it will take care of the provisioning process for you.



Step 3: Create and Push Docker Image

*3.1 Build Docker Image*
To containerize the web application, you first need to build the Docker image using your Dockerfile. Follow the instructions below to build and push the image to Docker Hub (or ECR if needed).

Make sure Docker is installed on your machine by following the installation guide above.

Build the Docker image:

**docker build -t my-web-app .** #Tag the Docker image with your Docker Hub username:
**docker tag my-web-app <docker-hub-username>/my-web-app:latest**

Push the image to Docker Hub:
***docker login***
**docker push <docker-hub-username>/my-web-app:latest**
Note: If you prefer to use AWS ECR instead of Docker Hub, you will need to create a repository in ECR and use the corresponding docker push commands for ECR. You can refer to the AWS ECR documentation for detailed instructions on how to do that.


**Step 4**
### 4.1 Configure kubectl to Use Your EKS Cluster
After Terraform provisions the EKS cluster, you need to configure `kubectl` to interact with it. Run the following command:
**aws eks --region us-west-2 update-kubeconfig --name web-app-cluster** ###This command updates your kubectl configuration to use the newly created EKS cluster, allowing you to manage resources within it.

**4.2 Deploy the Kubernetes Resources**
The Kubernetes deployment and service files (deployment.yaml and service.yaml) have already been created for you.

To deploy the application, apply the configuration files with kubectl:

kubectl apply -f deployment.yaml
kubectl apply -f service.yaml
These commands will create the necessary Kubernetes resources in your EKS cluster. The deployment.yaml defines the deployment for your web application, and the service.yaml exposes it externally via a LoadBalancer.

**4.3 Access the Web Application**
Once the deployment and service are successfully created, retrieve the external IP address assigned to your service:

kubectl get svc web-app-service
In the output, look for the EXTERNAL-IP column. Once an IP address is listed under that column, open it in your browser to access the web application.


***Install Prometheus for Monitoring***
Prometheus will scrape metrics from your Kubernetes cluster to monitor the application and infrastructure.

Install Prometheus using Helm: Add the Prometheus Helm repository and install Prometheus in the monitoring namespace:

helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
helm repo update

kubectl create namespace monitoring
helm install prometheus prometheus-community/kube-prometheus-stack --namespace monitoring
Verify Prometheus Installation: Check that Prometheus is running:

kubectl get pods -n monitoring
Access Prometheus UI: To access Prometheus UI, port-forward the service to your local machine:
kubectl port-forward svc/prometheus-kube-prometheus-prometheus -n monitoring 9090:9090
Open http://localhost:9090 to access the Prometheus web UI.

Verify Metrics: Once Prometheus is running, you can run queries to monitor the metrics of your Kubernetes pods and web application.

For example, to view CPU usage of the web-app pod, use the query:

promQL
rate(container_cpu_usage_seconds_total{namespace="default", pod="web-app-deployment"}[1m])

***7. Clean Up Resources***
Once you're done testing, you can clean up the resources.

Uninstall Prometheus:

helm uninstall prometheus -n monitoring
Delete the Kubernetes Resources:

kubectl delete -f deployment.yaml
kubectl delete -f service.yaml
Destroy Terraform Infrastructure:

terraform destroy

