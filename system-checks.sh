#!/bin/bash

set -e

NAMESPACE="devops-challenge"
APP_LABEL="app.kubernetes.io/name=devops-challenge"

echo "Running system checks..."

# Get Pod name
POD_NAME=$(kubectl get pods -n $NAMESPACE -l $APP_LABEL -o jsonpath="{.items[0].metadata.name}")

echo "Using Pod: $POD_NAME"
echo

# Check UID (prove non-root)
echo "Checking user running inside the container:"
kubectl exec -n $NAMESPACE $POD_NAME -- id
echo

# Check port binding via Pod spec (BEST PRACTICE)
echo "Checking application port binding (from Pod spec):"
kubectl get pod -n $NAMESPACE $POD_NAME \
  -o jsonpath="{.spec.containers[0].ports[0].containerPort}"
echo
echo

# Validate application response via port-forward
echo "Validating application response via curl..."

kubectl port-forward pod/$POD_NAME 8080:80 -n $NAMESPACE > /dev/null 2>&1 &
PF_PID=$!

sleep 5

curl http://localhost:8080
echo

kill $PF_PID

echo
echo "System checks completed successfully!"
