kubectl apply -f "https://cloud.weave.works/k8s/scope.yaml?k8s-version=$(kubectl version | base64 | tr -d '\n')"
sleep 10
kubectl port-forward -n weave "$(kubectl get -n weave pod --selector=weave-scope-component=app -o jsonpath='{.items..metadata.name}')" 4040  &
#insecure, use from localhost
#sudo iptables -t nat -I PREROUTING -p tcp --dport 4040 -j DNAT --to 127.0.0.1:4040
