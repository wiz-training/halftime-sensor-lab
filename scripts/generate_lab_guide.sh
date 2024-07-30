export APP_URL=$(terraform -chdir=../terraform/ output -raw nginx_service_load_balancer_hostname)
export ATTACKER_IPV4=$(terraform -chdir=../terraform/ output -raw attacker_public_ipv4)
export IRSA_ROLE=$(terraform -chdir=../terraform/ output -raw irsa_role_arn)
export CUSTOMER_BUCKET=$(terraform -chdir=../terraform/ output -raw customer_info_bucket_name)
export WEB_BUCKET=$(terraform -chdir=../terraform/ output -raw web_app_bucket_name)

envsubst < ../lab/lab_guide_template.md > ../lab/lab_guide.md