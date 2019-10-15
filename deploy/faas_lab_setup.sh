function wait_for_worker {
  while [[ "$(kubectl get nodes | grep Ready | grep none | wc -l)" -lt 1 ]];
  do
    sleep 1
  done
}

function wait_for_podnetwork {
  #podnetwork should be running on the master and at least one worker node
  while [[ "$(kubectl get pods -n kube-system | grep weave-net | grep Running | wc -l)" -lt 2 ]];
  do
    sleep 1
  done
}

source nodes.conf
IFS=',' read -r -a NODES <<< "$NODELIST"

#Faas setup
./kubernetes_install.sh

./weavenet_setup.sh

#IP=$(ifconfig eno49 | grep "inet addr:" | awk '{print $2}' | cut -c6-):6443
IP=$(ip addr sh dev $(ip ro sh | grep default | awk '{print $5}') scope global | grep inet | awk '{split($2,addresses,"/"); print addresses[1]}'):6443
TOKEN=$(kubeadm token list | tail -n 1 | cut -d ' ' -f 1)
HASH=sha256:$(openssl x509 -pubkey -in /etc/kubernetes/pki/ca.crt | openssl rsa -pubin -outform der 2>/dev/null | openssl dgst -sha256 -hex | sed 's/^.* //')

for i in "${NODES[@]}"
do
  ssh "$i" -o "StrictHostKeyChecking no" "bash -s" < ./kubernetes_install.sh true $IP $TOKEN $HASH
done
 
#(ssh node2 -o "StrictHostKeyChecking no" "bash -s" < ./kubernetes_install.sh true $IP $TOKEN $HASH > /dev/null &)
#ssh node2 kubeadm join $IP --token $TOKEN --discovery-token-ca-cert-hash $HASH
#sleep 60

wait_for_worker

#IP=$(ifconfig eno49 | grep "inet addr:" | awk '{print $2}' | cut -c6-):5000
IP=$(ip addr sh dev $(ip ro sh | grep default | awk '{print $5}') scope global | grep inet | awk '{split($2,addresses,"/"); print addresses[1]}'):5000
./docker_registry_setup.sh $IP

for i in "${NODES[@]}"
do
  ssh $i -o "StrictHostKeyChecking no" "bash -s" < ./docker_registry_setup.sh $IP
done

#wait_for_podnetwork

./helm_setup.sh
./metrics_setup.sh
./openfaas_setup.sh
./faas_idler_setup.sh
./faas_cli_install.sh

curl -sSL https://cli.openfaas.com | sudo sh
#kubectl port-forward -n monitoring prometheus-kube-prometheus-0 9090 &
#kubectl port-forward $(kubectl get  pods --selector=app=kube-prometheus-grafana -n  monitoring --output=jsonpath="{.items..metadata.name}") -n monitoring  3000 &
#kubectl port-forward -n monitoring alertmanager-kube-prometheus-0 9093 &

#./kubernetes_dashboard_install.sh
./kube_dashboard_setup.sh
./istio_install.sh
./kube_grafana.sh
./weave_scope_setup.sh
./custom_metrics_setup.sh
./redis_install.sh
./elk_setup.sh
ssh node2 -o "StrictHostKeyChecking no" "apt-get update && apt-get install apache2-utils"

