# Create Kubernetes Namespace
resource "kubernetes_namespace" "devops_challenge" {
  metadata {
    name = "devops-challenge"
  }
}

# Apply ResourceQuota to limit memory usage
resource "kubernetes_resource_quota" "memory_quota" {
  metadata {
    name      = "devops-challenge-quota"
    namespace = kubernetes_namespace.devops_challenge.metadata[0].name
  }

  spec {
    hard = {
      "limits.memory" = "512Mi"
      "requests.memory" = "512Mi"
    }
  }
}
