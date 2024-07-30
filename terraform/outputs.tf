output "update_kubectl" {
  value = "AWS_PROFILE='${local.profile}' aws eks update-kubeconfig --region ${local.region} --name ${local.cluster_name}"
}

output "access_key_id" {
  value = aws_iam_access_key.admin_key.id
}

output "secret_access_key" {
  value     = aws_iam_access_key.admin_key.secret
  sensitive = true
}

output "attacker_public_ipv4" {
  value = aws_instance.attacker_instance.public_ip
}

output "nginx_service_load_balancer_hostname" {
  value = data.kubernetes_service.nginx_service.status[0].load_balancer[0].ingress[0].hostname
}
