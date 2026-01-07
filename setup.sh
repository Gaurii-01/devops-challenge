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

# Step 4: Deploy using Helm
echo "Deploying application using Helm..."
helm upgrade --install devops-challenge ./helm/devops-challenge \
  --namespace devops-challenge \
  --create-namespace \
  --values ./helm/devops-challenge/values.yaml

echo "Local deployment completed successfully!"
