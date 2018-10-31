#!/bin/bash
helm repo add coreos https://s3-eu-west-1.amazonaws.com/coreos-charts/stable/
helm install coreos/prometheus-operator --name prometheus-operator --namespace monitoring
helm install coreos/kube-prometheus --name kube-prometheus --set global.rbacEnable=true --namespace monitoring

sleep 60

kubectl port-forward -n monitoring prometheus-kube-prometheus-0 9090 &
kubectl port-forward $(kubectl get  pods --selector=app=kube-prometheus-grafana -n  monitoring --output=jsonpath="{.items..metadata.name}") -n monitoring  3000 &
kubectl port-forward -n monitoring alertmanager-kube-prometheus-0 9093 &

#Forward localhost ports to external IP, kubectl port worward only forwards to localhost ¯\_(ツ)_/¯
sudo sysctl -w net.ipv4.conf.all.route_localnet=1
sudo iptables -t nat -I PREROUTING -p tcp --dport 9090 -j DNAT --to 127.0.0.1:9090
sudo iptables -t nat -I PREROUTING -p tcp --dport 3000 -j DNAT --to 127.0.0.1:3000
sudo iptables -t nat -I PREROUTING -p tcp --dport 9093 -j DNAT --to 127.0.0.1:9093
