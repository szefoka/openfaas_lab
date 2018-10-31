function wait_for_weavescope {
  while [[ "$(kubectl get pods -n weave | grep weave-scope-agent | grep Running | wc -l)" -lt  "$(kubectl get nodes | tail -n +2 | wc -l)" ]];
  do
    sleep 1
  done
  while [[ "$(kubectl get pods -n weave | grep weave-scope-app | grep Running | wc -l)" -lt 1 ]];
  do
    sleep 1
  done
}

kubectl apply -f "https://cloud.weave.works/k8s/scope.yaml?k8s-version=$(kubectl version | base64 | tr -d '\n')"
wait_for_weavescope
kubectl port-forward -n weave "$(kubectl get -n weave pod --selector=weave-scope-component=app -o jsonpath='{.items..metadata.name}')" 4040  &
#insecure, use from localhost
#sudo iptables -t nat -I PREROUTING -p tcp --dport 4040 -j DNAT --to 127.0.0.1:4040
