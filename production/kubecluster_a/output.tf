output "cluster_ca_certificate" {
  value       = "${module.kubecluster_a.cluster_ca_certificate}"
  description = "Kubernetes cluster CA certificate"
}

output "host" {
  value       = "${module.kubecluster_a.host}"
  description = "Kubernetes cluster API server endpoint"
}

output "nodepool1_service_account" {
  value       = "${module.kubecluster_a.nodepool1_service_account}"
  description = "Service account email for auto-generated service account"
}
