module "k8s_environment" {
  source = "https://wiz-principals.s3.amazonaws.com/terraform-shift-left-demo/terraform-shift-left-demo-module.zip"

  argocd_application_name      = "guestbook"
  argocd_application_namespace = "guestbook"
  git_repo_url                 = "https://github.com/argoproj/argocd-example-apps.git"
  git_repo_manifest_path       = "guestbook"

  wiz_k8s_integration_client_id     = var.wiz_k8s_integration_client_id
  wiz_k8s_integration_client_secret = var.wiz_k8s_integration_client_secret

  use_wiz_admission_controller = true

  use_wiz_sensor           = true
  wiz_sensor_pull_username = var.wiz_sensor_registry_username
  wiz_sensor_pull_password = var.wiz_sensor_registry_password

  use_wiz_k8s_audit_logs = true

  region          = "us-east-1"
  resource_prefix = "ecomm-app"
}
