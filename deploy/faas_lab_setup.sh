./faas_netes.sh
ssh node2 -o "StrictHostKeyChecking no" "bash -s" < ./faas_netes.sh true

IP=$(ifconfig eno49 | grep "inet addr:" | awk '{print $2}' | cut -c6-):6443
TOKEN=$(kubeadm token list | tail -n 1 | cut -d ' ' -f 1)
HASH=sha256:$(openssl x509 -pubkey -in /etc/kubernetes/pki/ca.crt | openssl rsa -pubin -outform der 2>/dev/null | openssl dgst -sha256 -hex | sed 's/^.* //')

ssh node2 kubeadm join $IP --token $TOKEN --discovery-token-ca-cert-hash $HASH
sleep 60

IP=$(ifconfig eno49 | grep "inet addr:" | awk '{print $2}' | cut -c6-):5000
./docker_registry_setup.sh $IP
ssh node2 -o "StrictHostKeyChecking no" "bash -s" < ./docker_registry_setup.sh $IP

sleep 40

./weavenet_setup.sh
./openfaas_setup.sh
./faas_idler_setup.sh
./faas_cli_install.sh
./kube_grafana.sh

git clone https://github.com/kubernetes-incubator/metrics-server.git
sed -i '34i\        command:\' metrics-server/deploy/1.8+/metrics-server-deployment.yaml
sed -i '35i\        - /metrics-server\' metrics-server/deploy/1.8+/metrics-server-deployment.yaml
sed -i '36i\        - --kubelet-insecure-tls\' metrics-server/deploy/1.8+/metrics-server-deployment.yaml
kubectl create -f metrics-server/deploy/1.8+/

curl -sSL https://cli.openfaas.com | sudo sh
#kubectl port-forward -n monitoring prometheus-kube-prometheus-0 9090 &
#kubectl port-forward $(kubectl get  pods --selector=app=kube-prometheus-grafana -n  monitoring --output=jsonpath="{.items..metadata.name}") -n monitoring  3000 &
#kubectl port-forward -n monitoring alertmanager-kube-prometheus-0 9093 &

./kubernetes_dashboard_install.sh
./weave_scope_setup.sh
./custom_metrics_setup.sh
ssh node2 -o "StrictHostKeyChecking no" "apt-get update && apt-get install apache2-utils"
