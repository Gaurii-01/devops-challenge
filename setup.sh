#!/bin/bash

set -e

echo "Starting local DevOps Challenge setup..."

# Step 1: Build Docker image
echo "Building Docker image..."
docker build -t devops-challenge:latest .

# Step 2: Load image into Minikube (only if minikube exists)
if command -v minikube >/dev/null 2>&1; then
  echo "Loading image into Minikube..."
  minikube image load devops-challenge:latest
else
  echo "minikube not found in this environment. Skipping image load."
  echo "(This is expected when running from WSL on Windows)"
fi

# Step 3: Terraform init & apply
echo "Applying Terraform configuration..."
cd terraform
terraform init
terraform apply -auto-approve
cd ..

#Step 4: Deply to Helm
echo "Deploying application using Helm..."

if command -v minikube >/dev/null 2>&1; then
  echo "Minikube detected - using local Docker image"
  helm upgrade --install devops-challenge ./helm/devops-challenge \
    --namespace devops-challenge \
    --create-namespace \
    -f helm/devops-challenge/values-minikube.yaml
else
  echo "Minikube not detected - using Docker Hub image"
  helm upgrade --install devops-challenge ./helm/devops-challenge \
    --namespace devops-challenge \
    --create-namespace
fi

echo "Local deployment completed successfully!"
