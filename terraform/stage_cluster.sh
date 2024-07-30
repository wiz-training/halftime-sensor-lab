aws eks --region ${{ vars.REGION }} update-kubeconfig --name ${{ vars.CLUSTER_NAME }} 

if ! helm repo list | grep -q 'wiz-sec'; then
    helm repo add wiz-sec https://charts.wiz.io/
fi

helm repo update

kubectl get namespace wiz || kubectl create namespace wiz

if ! kubectl -n wiz get secret sensor-image-pull; then
    kubectl -n wiz create secret docker-registry sensor-image-pull \
        --docker-server=wizio.azurecr.io/sensor \
        --docker-username=${{ secrets.SENSOR_PULLKEY_USERNAME }} \
        --docker-password=${{ secrets.SENSOR_PULLKEY_PASSWORD }}
fi

if ! kubectl -n wiz get secret wiz-api-token; then
    kubectl -n wiz create secret generic wiz-api-token \
        --from-literal=clientId=${{ secrets.WIZ_SERVICE_ACCOUNT_ID }} \
        --from-literal=clientToken=${{ secrets.WIZ_SERVICE_ACCOUNT_TOKEN }}
fi

cat <<EOF >./values.yaml
    global:
        wizApiToken:
        secret:
            create: false 
            name: "wiz-api-token"
        clientEndpoint: "" 

    wiz-kubernetes-connector:
        enabled: true
        autoCreateConnector:
        connectorName: "tasky-app-cluster"
        broker:
        enabled: true

    wiz-sensor:
        enabled: true
        imagePullSecret:
        create: false
        name: "sensor-image-pull"

    wiz-admission-controller:
        enabled: true

        kubernetesAuditLogsWebhook:
        enabled: true

        imageIntegrityWebhook:
        enabled: false
    EOF

      - name: Deploy Security Tooling Helm Release
        run: |
          helm upgrade --install wiz-integration wiz-sec/wiz-kubernetes-integration \
            --values values.yaml -n wiz
