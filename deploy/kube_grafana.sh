#!/bin/bash
helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
helm repo add stable https://charts.helm.sh/stable
helm repo update

helm install kube-grafana prometheus-community/kube-prometheus-stack

sleep 60

kubectl patch service kube-grafana --type=json -p='[{"op":"add", "path": "/spec/type", "value": LoadBalancer}]'
#kubectl port-forward -n monitoring prometheus-kube-prometheus-0 9090 &
#kubectl port-forward $(kubectl get  pods --selector=app=kube-prometheus-grafana -n  monitoring --output=jsonpath="{.items..metadata.name}") -n monitoring  3000 &
#kubectl port-forward -n monitoring alertmanager-kube-prometheus-0 9093 &

#Forward localhost ports to external IP, kubectl port worward only forwards to localhost ¯\_(ツ)_/¯
#sudo sysctl -w net.ipv4.conf.all.route_localnet=1
#sudo iptables -t nat -I PREROUTING -p tcp --dport 9090 -j DNAT --to 127.0.0.1:9090
#sudo iptables -t nat -I PREROUTING -p tcp --dport 3000 -j DNAT --to 127.0.0.1:3000
#sudo iptables -t nat -I PREROUTING -p tcp --dport 9093 -j DNAT --to 127.0.0.1:9093
